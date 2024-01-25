import QtQuick 2.12
import QtQuick.Controls 2.12

CompNumpadBtn {
    id: compAlphaNumPinBtnRoot

    property var listOfOptions: ['2','A','B','C']
    property int optionsIndex: 0
    property bool updatingIndexInternal: false
    property int numPinEntry: 0
    property int maxPinLength: 5
    property CompNumpadBtn currentPinBtn: CompNumpadBtn{ text: "Text"}


    signal alphaNumPinClicked(string txt)

    onCurrentPinBtnChanged: {
        if(!currentPinBtn)
        {
            return
        }

        if(currentPinBtn === this)
        {
            return
        }

        optionsIndex = 0
    }

    onOptionsIndexChanged: {
        if(!updatingIndexInternal &&  optionsIndex >= listOfOptions.length)
        {
            updatingIndexInternal = true
            optionsIndex = 0
            updatingIndexInternal = false
        }
    }


    onClicked: txt => {
                   if (numPinEntry === maxPinLength)
                   {
                       return
                   }

                   compAlphaNumPinBtnRoot.alphaNumPinClicked(listOfOptions[optionsIndex])

                   optionsIndex += 1

               }


    text: listOfOptions[0]


    Row{
        anchors{
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }
        spacing: 4
        Repeater{
            model: compAlphaNumPinBtnRoot.listOfOptions.length - 1

            CompLabel{
                text: compAlphaNumPinBtnRoot.listOfOptions[index + 1]
                bottomPadding: 20
                font{
                    pixelSize: 12
                }
            }
        }
    }


}
