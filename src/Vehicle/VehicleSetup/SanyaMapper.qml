/****************************************************************************
 *
 * (c) 2009-2024 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick
import QtQuick.Controls

import QGroundControl

import QGroundControl.Controls

Rectangle {
    id: root
    anchors.fill: parent
    color: qgcPal.window

    QGCPalette {
        id: qgcPal
        colorGroupEnabled: true
    }
}
