/****************************************************************************
 * This file is part of Green Island.
 *
 * Copyright (C) 2014 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 *
 * Author(s):
 *    Pier Luigi Fiorini
 *
 * $BEGIN_LICENSE:GPL2+$
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
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

WindowAnimation {
    id: animation

    Scale {
        id: transform
        origin.x: animation.windowItem.width / 2
        origin.y: animation.windowItem.height / 2
        xScale: 0.01
        yScale: 0.1
    }

    mapAnimation: ParallelAnimation {
        NumberAnimation {
            target: animation.windowItem
            property: "opacity"
            easing.type: Easing.Linear
            to: 1.0
            duration: 250
        }

        SequentialAnimation {
            ScriptAction {
                script: animation.windowItem.transform = transform
            }

            ParallelAnimation {
                NumberAnimation {
                    target: transform
                    property: "xScale"
                    easing.type: Easing.OutExpo
                    to: 1.0
                    duration: 350
                }

                NumberAnimation {
                    target: transform
                    property: "yScale"
                    easing.type: Easing.OutExpo
                    to: 1.0
                    duration: 350
                }
            }
        }
    }

    unmapAnimation: NumberAnimation {
        target: animation.windowItem
        property: "opacity"
        easing.type: Easing.Linear
        to: 0.0
        duration: 250
    }
}