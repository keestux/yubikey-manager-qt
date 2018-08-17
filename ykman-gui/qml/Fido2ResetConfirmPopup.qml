import QtQuick 2.5
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.2
import "slotutils.js" as SlotUtils

InlinePopup {

    Label {
        width: parent.width
        text: qsTr("Are you sure you want to reset FIDO? This will delete all FIDO credentials, including FIDO U2F credentials.

This action cannot be undone!")
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        color: yubicoBlue
        font.pointSize: constants.h2
        wrapMode: Text.WordWrap
        Layout.maximumWidth: parent.width
    }
    standardButtons: Dialog.No | Dialog.Yes
}
