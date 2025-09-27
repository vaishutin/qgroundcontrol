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
import QtQuick.Layouts

import QGroundControl

import QGroundControl.Controls

ColumnLayout {
    width:      availableWidth
    spacing:    ScreenTools.defaultFontPixelHeight

    readonly property int __buttonLimit: _maxButtons

    function axisPercentFromRaw(value) {
        if (value === undefined || value === null) {
            return 50;
        }
        const min = -32768;
        const max = 32767;
        const clamped = Math.max(min, Math.min(max, value));
        return Math.round(((clamped - min) / (max - min)) * 100);
    }

    Connections {
        target: _activeJoystick
        onRawAxisValueChanged: (axis, value) => {
            if (axisRepeater.itemAt(axis)) {
                axisRepeater.itemAt(axis).axisPercent = axisPercentFromRaw(value)
            }
        }
        onRawButtonPressedChanged: (index, pressed) => {
            if (buttonRepeater.itemAt(index)) {
                buttonRepeater.itemAt(index).buttonPercent = pressed ? 100 : 0
            }
        }
    }

    QGCLabel {
        Layout.alignment:   Qt.AlignHCenter
        visible:            !_activeJoystick
        text:               qsTr("Connect a joystick to view mapping information.")
    }

    ScrollView {
        id:                 mappingScroll
        Layout.fillWidth:   true
        Layout.fillHeight:  true
        visible:            _activeJoystick

        ColumnLayout {
            width:      parent.width
            spacing:    ScreenTools.defaultFontPixelHeight

            QGCLabel {
                Layout.fillWidth:   true
                wrapMode:           Text.WordWrap
                visible:            _activeJoystick && _activeJoystick.axisCount === 0 && _activeJoystick.totalButtonCount === 0
                text:               qsTr("No axes or buttons detected on the active joystick.")
            }

            ColumnLayout {
                Layout.fillWidth:   true
                visible:            _activeJoystick && _activeJoystick.axisCount > 0
                spacing:            ScreenTools.defaultFontPixelHeight / 2

                QGCLabel {
                    Layout.fillWidth:   true
                    font.bold:          true
                    text:               qsTr("Axes")
                }

                Repeater {
                    id:     axisRepeater
                    model:  _activeJoystick ? _activeJoystick.axisCount : 0

                    RowLayout {
                        Layout.fillWidth:   true
                        spacing:            ScreenTools.defaultFontPixelWidth

                        property real axisPercent: 50

                        QGCLabel {
                            Layout.preferredWidth: ScreenTools.defaultFontPixelWidth * 12
                            text:                   qsTr("Axis %1").arg(modelData)
                        }

                        ProgressBar {
                            Layout.fillWidth:   true
                            from:               0
                            to:                 100
                            value:              axisPercent
                        }

                        QGCLabel {
                            Layout.preferredWidth: ScreenTools.defaultFontPixelWidth * 6
                            horizontalAlignment:    Text.AlignRight
                            text:                   Math.round(axisPercent) + "%"
                        }
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth:   true
                visible:            _activeJoystick && _activeJoystick.totalButtonCount > 0
                spacing:            ScreenTools.defaultFontPixelHeight / 2

                QGCLabel {
                    Layout.fillWidth:   true
                    font.bold:          true
                    text:               qsTr("Buttons")
                }

                Repeater {
                    id:     buttonRepeater
                    model:  _activeJoystick ? Math.min(_activeJoystick.totalButtonCount, __buttonLimit) : 0

                    RowLayout {
                        Layout.fillWidth:   true
                        spacing:            ScreenTools.defaultFontPixelWidth

                        property real buttonPercent: 0

                        QGCLabel {
                            Layout.preferredWidth: ScreenTools.defaultFontPixelWidth * 12
                            text:                   qsTr("Button %1").arg(modelData)
                        }

                        ProgressBar {
                            Layout.fillWidth:   true
                            from:               0
                            to:                 100
                            value:              buttonPercent
                        }

                        QGCLabel {
                            Layout.preferredWidth: ScreenTools.defaultFontPixelWidth * 6
                            horizontalAlignment:    Text.AlignRight
                            text:                   Math.round(buttonPercent) + "%"
                        }
                    }
                }
            }
        }
    }
}
