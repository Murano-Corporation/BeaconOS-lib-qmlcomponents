import QtQuick 2.12

import QtQuick.Controls 2.12

Item {
    id: compHealthDashboardTableItemDel_Params_Root

    property var myModel: undefined
    property var myData: myModel.display
    property string paramName: myModel !== undefined ? myModel.ParamName ? myModel.ParamName : '' : ''

    property int col: myModel.column
    property int row: myModel.row
    property color gridLineColor: "White"
    property int columns: 1
    property int rows: 1
    property int selectedRow: -1
    property bool showRowNum: true
    /** POSSIBLE VALUES
      * - text = Only shows textual data
      * - image = Only shows image data
*/
    property string dataType: "text"

    signal actionClickedShowGraph(string paramName)
    signal clicked()

    Rectangle {

        property color colorNotSelected: "#1E273A"
        property color colorSelected: "#2B3853"

        anchors{
            fill: parent
        }

        color: (tableView.selectedRow === myModel.row) ? colorSelected : colorNotSelected
    }

    Rectangle{
        id: gridLeft

        anchors{
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }

        width: (parent.col === 0 ? 2 : 1)
        color: compHealthDashboardTableItemDel_Params_Root.gridLineColor
    }

    Rectangle{
        id: gridRight

        anchors{
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }

        width: ((parent.col === (compHealthDashboardTableItemDel_Params_Root.columns - 1)) ? 2 : 1)
        color: compHealthDashboardTableItemDel_Params_Root.gridLineColor
    }

    Rectangle{
        id: gridTop

        anchors{
            right: parent.right
            left: parent.left
            top: parent.top

        }

        height: ((parent.row === 0) ? 2 : 1)
        color: compHealthDashboardTableItemDel_Params_Root.gridLineColor
    }

    Rectangle{
        id: gridBottom

        anchors{
            right: parent.right
            left: parent.left
            bottom: parent.bottom

        }

        height: ((parent.row === (compHealthDashboardTableItemDel_Params_Root.rows - 1)) ? 2 : 1)
        color: compHealthDashboardTableItemDel_Params_Root.gridLineColor
    }

    Item {
        id: displayContent

        anchors{
            top: gridTop.bottom
            left: gridLeft.right
            right: gridRight.left
            bottom: gridBottom.top
        }

        Image{
            id: imgContent

            property string imgUrl: myData ? (compHealthDashboardTableItemDel_Params_Root.dataType === 'image' ? myData : '') : ''

            visible: compHealthDashboardTableItemDel_Params_Root.dataType === 'image' && compHealthDashboardTableItemDel_Params_Root.visible

            anchors{
                fill: parent
            }
            asynchronous: true
            source: visible ? ( imgUrl !== '' ? "file://" + imgUrl : '' ): ""
            fillMode: Image.PreserveAspectFit
            sourceSize: Qt.size(imgContent.width, imgContent.height)
        }

        CompLabel{
            id: textContent

            property string myText:{
                if( !visible )
                   return ''

                if( !myData )
                    return ''

                var ret = ''
                if(  col === 0 && showRowNum )
                    ret += "(" + row +") - "

                ret += myData

                return ret
            }

            visible: compHealthDashboardTableItemDel_Params_Root.dataType === 'text'
            elide: Text.ElideRight
            text:  myText

            anchors{
                fill: parent
            }

            font{
                pixelSize: 20
                weight: Font.Light
            }

            leftPadding: 20
            rightPadding: 20

            verticalAlignment: "AlignVCenter"
            horizontalAlignment: ((compHealthDashboardTableItemDel_Params_Root.col === 1) ? "AlignRight" : ((compHealthDashboardTableItemDel_Params_Root.col === 3 || compHealthDashboardTableItemDel_Params_Root.col === 4) ? "AlignHCenter" : "AlignLeft"))
        }

        Item{
            id: actionsContent

            visible: compHealthDashboardTableItemDel_Params_Root.dataType === 'actions'

            anchors.fill:parent

            CompIconBtn{
                id: btnShowGraph

                height: parent.height
                width: height

                iconUrl: "file:///usr/share/BeaconOS-lib-images/images/GraphFill.svg"

                iconColor: "White"

                onClicked: {

                    console.log("Clicked in low")
                    compHealthDashboardTableItemDel_Params_Root.actionClickedShowGraph(compHealthDashboardTableItemDel_Params_Root.paramName)
                }
            }
        }

    }



    MouseArea {
        enabled: compHealthDashboardTableItemDel_Params_Root.dataType !== 'actions'

        anchors{
            fill: parent


        }

        onClicked: compHealthDashboardTableItemDel_Params_Root.clicked()
    }


}
