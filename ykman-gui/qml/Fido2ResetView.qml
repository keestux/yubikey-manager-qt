import QtQuick 2.5
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import QtQuick.Controls.Material 2.2

ColumnLayout {

    readonly property bool hasDevice: yubiKey.hasDevice
    property bool loadedReset
    onHasDeviceChanged: resetOnReInsert()

    function resetOnReInsert() {
        if (!hasDevice && reInsertYubiKey.visible) {
            loadedReset = true
        } else {
            if (loadedReset) {
                loadedReset = false
                touchYubiKey.open()
                yubiKey.fido_reset(function (resp) {
                    touchYubiKey.close()
                    if (resp.success) {
                        fido2SuccessPopup.open()
                    } else {
                        if (resp.error === 'touch timeout') {
                            fido2ResetTouchError.open()
                        } else {
                            fido2GeneralError.error = resp.error
                            fido2GeneralError.open()
                        }
                    }
                })
            }
        }
    }

    TouchYubiKeyPopup {
        id: touchYubiKey
    }

    Fido2ResetConfirmPopup {
        id: fido2ResetConfirmationPopup
        onAccepted: reInsertYubiKey.open()
    }

    Fido2GeneralErrorPopup {
        id: fido2ResetTouchError
        error: qsTr("A reset requires a touch on the YubiKey to be confirmed.")
    }

    Fido2GeneralErrorPopup {
        id: fido2GeneralError
    }

    ColumnLayout {
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.margins: constants.contentMargins
        Layout.topMargin: constants.contentTopMargin
        Layout.bottomMargin: constants.contentBottomMargin
        Layout.preferredHeight: constants.contentHeight
        Layout.maximumHeight: constants.contentHeight
        Layout.preferredWidth: constants.contentWidth
        Layout.maximumWidth: constants.contentWidth
        spacing: 20

        ColumnLayout {
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            Heading1 {
                text: qsTr("Reset FIDO")
            }

            BreadCrumbRow {
                BreadCrumb {
                    text: qsTr("Home")
                    action: views.home
                }

                BreadCrumbSeparator {
                }
                BreadCrumb {
                    text: qsTr("FIDO2")
                    action: views.fido2
                }

                BreadCrumbSeparator {
                }
                BreadCrumb {
                    text: qsTr("Reset FIDO")
                    active: true
                }
            }
        }

        Label {
            color: yubicoBlue
            text: qsTr("This action permanently deletes all FIDO credentials on the device (U2F & FIDO2), and removes the FIDO2 PIN.")
            verticalAlignment: Text.AlignVCenter
            Layout.fillWidth: true
            Layout.maximumWidth: parent.width
            wrapMode: Text.WordWrap
            font.pointSize: constants.h3
        }

        RowLayout {
            Layout.alignment: Qt.AlignRight | Qt.AlignBottom
            Layout.fillWidth: true
            Button {
                text: qsTr("Back")
                onClicked: views.pop()
                icon.source: "../images/back.svg"
                icon.width: 16
                icon.height: 16
                font.capitalization: Font.MixedCase
                font.family: constants.fontFamily
                Material.foreground: yubicoBlue
            }
            Button {
                text: qsTr("Reset")
                highlighted: true
                onClicked: fido2ResetConfirmationPopup.open()
                ToolTip.delay: 1000
                ToolTip.visible: hovered
                ToolTip.text: qsTr("Finish and perform the FIDO Reset")
                icon.source: "../images/finish.svg"
                icon.width: 16
                icon.height: 16
                font.capitalization: Font.MixedCase
                font.family: constants.fontFamily
            }
        }
    }
}
