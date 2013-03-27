/****************************************************************************
 * This file is part of Desktop Shell.
 *
 * Copyright (C) 2012-2013 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 *
 * Author(s):
 *    Pier Luigi Fiorini
 *
 * $BEGIN_LICENSE:LGPL2.1+$
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 2.1 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * $END_LICENSE$
 ***************************************************************************/

#include <QGuiApplication>
#include <QQuickWindow>

#include "waylandintegration.h"
#include "desktopshell.h"
#include "notificationsdaemon.h"
#include "shellui.h"

Q_GLOBAL_STATIC(WaylandIntegration, s_waylandIntegration)

const struct wl_registry_listener WaylandIntegration::registryListener = {
    WaylandIntegration::handleGlobal
};

const struct hawaii_desktop_shell_listener WaylandIntegration::shellListener = {
    WaylandIntegration::handlePresent,
    WaylandIntegration::handlePrepareLockSurface,
    WaylandIntegration::handleGrabCursor
};

WaylandIntegration::WaylandIntegration()
    : shell(0)
    , notification(0)
{
}

WaylandIntegration *WaylandIntegration::instance()
{
    return s_waylandIntegration();
}

void WaylandIntegration::handleGlobal(void *data,
                                      struct wl_registry *registry,
                                      uint32_t id,
                                      const char *interface,
                                      uint32_t version)
{
    Q_UNUSED(version);

    WaylandIntegration *object = static_cast<WaylandIntegration *>(data);

    if (strcmp(interface, "hawaii_desktop_shell") == 0) {
        // Bind interface and register listener
        object->shell = static_cast<struct hawaii_desktop_shell *>(
                    wl_registry_bind(registry, id, &hawaii_desktop_shell_interface, 1));
        hawaii_desktop_shell_add_listener(object->shell, &shellListener, data);

        // Create shell surfaces
        DesktopShell *shell = DesktopShell::instance();
        QMetaObject::invokeMethod(shell, "create");
    } else if (strcmp(interface, "wl_notification_daemon") == 0) {
        // Bind interface
        object->notification = static_cast<struct wl_notification_daemon *>(
                    wl_registry_bind(registry, id, &wl_notification_daemon_interface, 1));

        // Start the notifications daemon and connect to the session bus
        NotificationsDaemon *daemon = NotificationsDaemon::instance();
        QMetaObject::invokeMethod(daemon, "connectOnDBus");
    }
}

void WaylandIntegration::handlePresent(void *data,
                                       struct hawaii_desktop_shell *desktop_shell,
                                       struct wl_surface *surface)
{
    Q_UNUSED(desktop_shell);

    WaylandIntegration *object = static_cast<WaylandIntegration *>(data);
    Q_ASSERT(object);

    DesktopShell *shell = DesktopShell::instance();

    foreach (ShellUi *shellUi, shell->windows()) {
        if (surface == shellUi->backgroundSurface()) {
            QMetaObject::invokeMethod(shellUi->backgroundWindow(), "show");
        } else if (surface == shellUi->panelSurface()) {
            QMetaObject::invokeMethod(shellUi->panelWindow(), "show");
            QMetaObject::invokeMethod(shellUi, "sendPanelGeometry");
        } else if (surface == shellUi->launcherSurface()) {
            QMetaObject::invokeMethod(shellUi->launcherWindow(), "show");
            QMetaObject::invokeMethod(shellUi, "sendLauncherGeometry");
        }
    }
}

void WaylandIntegration::handlePrepareLockSurface(void *data,
                                                  struct hawaii_desktop_shell *desktop_shell)
{
    hawaii_desktop_shell_unlock(desktop_shell);
}

void WaylandIntegration::handleGrabCursor(void *data,
                                          struct hawaii_desktop_shell *desktop_shell,
                                          uint32_t cursor)
{
    Q_UNUSED(data);
    Q_UNUSED(desktop_shell);
    Q_UNUSED(cursor);
}
