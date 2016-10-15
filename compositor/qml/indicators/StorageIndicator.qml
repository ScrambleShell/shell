/****************************************************************************
 * This file is part of Liri.
 *
 * Copyright (C) 2015-2016 Pier Luigi Fiorini
 *
 * Author(s):
 *    Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 *
 * $BEGIN_LICENSE:GPL3+$
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * $END_LICENSE$
 ***************************************************************************/

import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import Fluid.Controls 1.0
import Liri.Shell 1.0
import Vibe.Hardware 1.0 as Hardware

Indicator {
    title: qsTr("Storage")
    iconName: Qt.resolvedUrl("../images/harddisk.svg")
    visible: hardware.storageDevices.length > 0
    component: ListView {
        model: hardware.storageDevices
        clip: true

        delegate: ListItem {
            iconName: modelData.iconName + "-symbolic"
            text: modelData.name
            onClicked: processRunner.launchCommand("xdg-open file://" + modelData.filePath)

            rightItem: IconButton {
                anchors.centerIn: parent

                ToolTip.text: modelData.mounted ? qsTr("Eject") : qsTr("Mount")
                ToolTip.visible: hovered

                iconName: Qt.resolvedUrl("../images/" + (modelData.mounted ? "eject.svg" : "disc.svg"))
                onClicked: modelData.mounted ? modelData.unmount() : modelData.mount()
            }
        }
    }

    Hardware.HardwareEngine {
        id: hardware
    }
}