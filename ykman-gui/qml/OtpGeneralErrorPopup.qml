import QtQuick 2.5
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.2
import "slotutils.js" as SlotUtils

InlinePopup {
    property string error

    Label {
        width: parent.width
        text: qsTr("Error!

Failed to configure " + SlotUtils.slotNameCapitalized(views.selectedSlot) + ".

" + error)
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        color: yubicoBlue
        font.pointSize: constants.h2
        wrapMode: Text.WordWrap
    }

    standardButtons: Dialog.Ok
}
