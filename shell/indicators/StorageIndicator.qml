/****************************************************************************
 * This file is part of Hawaii.
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
import Hawaii.Desktop 1.0
import Hawaii.Hardware 1.0 as Hardware

Indicator {
    name: "storage"
    iconName: Qt.resolvedUrl("../images/harddisk.svg")
    component: Component {
        ColumnLayout {
            spacing: Units.largeSpacing

            HeadlineLabel {
                text: qsTr("Volumes")
            }

            Repeater {
                model: hardware.storageDevices

                RowLayout {
                    spacing: Units.smallSpacing

                    RowLayout {
                        spacing: Units.smallSpacing

                        Icon {
                            name: modelData.iconName + "-symbolic"
                            size: Units.iconSizes.large

                            MouseArea {
                                anchors.fill: parent
                                onClicked: processRunner.launchCommand("xdg-open file://" + modelData.filePath)
                            }
                        }

                        Label {
                            id: label
                            text: modelData.name

                            MouseArea {
                                anchors.fill: parent
                                onClicked: processRunner.launchCommand("xdg-open file://" + modelData.filePath)
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        IconButton {
                            ToolTip.text: modelData.mounted ? qsTr("Eject") : qsTr("Mount")
                            ToolTip.visible: hovered

                            iconName: Qt.resolvedUrl("../images/" + (modelData.mounted ? "eject.svg" : "disc.svg"))
                            onClicked: modelData.mounted ? modelData.unmount() : modelData.mount()
                        }
                    }

                    Layout.fillWidth: true
                }
            }

            Item {
                Layout.fillHeight: true
            }
        }
    }
    visible: hardware.storageDevices.length > 0

    Hardware.HardwareEngine {
        id: hardware
    }
}
