import QtQuick 2.12
import QtQuick.Controls 2.12

Comp__BASE {
    id: compHealthDashboardContentContextNav

    property bool isMTConnectData: false
    property string systemSelected: "null"
    property string context1Selected: "null"
    property string mtcSortFilterString
    property string context2Selected: "null"
    property bool isMaxWidth: true
    property bool isMaxHeight: false
    property alias btnHeight: viewSystemType.btnHeight
    property alias btnSpacing: viewSystemType.btnSpacing

    property var modelData_EnvImuJ1939J1708_Context1: TableModelHealthDashboard.listOfContext1Options
    property var modelData_MTC_Context1: TableModelMTConnect_Context1

    property var modelData_Context1: (isMTConnectData ? modelData_MTC_Context1 : modelData_EnvImuJ1939J1708_Context1)

    function getContext1Name(iIndex, model)
    {
        if( isMTConnectData )
        {
            return model.display
        } else {
            return TableModelHealthDashboard.getContext1Name(iIndex)
        }
    }

    Component.onCompleted: {

        if( !isMTConnectData )
        {
            MqttTopicCmdBOS.slot_Request_Context2Map(AssetInfo.beaconID);
        }


        systemSelected = "null"
    }

    onSystemSelectedChanged: {
        context1Selected = "null"
    }
    onContext1SelectedChanged: {
        context2Selected = "null"
    }

    Item {
        id: viewSystemType
        visible: parent.systemSelected === "null"

        property real btnSpacing: 41
        property real btnWidth: ((compHealthDashboardContentContextNav.width - btnSpacing) * 0.33)
        property real btnHeight: isDelta ? 303 : 350

        anchors{
            centerIn: parent
        }

        height: childrenRect.height
        width: childrenRect.width

        CompHealthContextNavBtn {
            id: navBtnBeacon

            anchors{
                left: parent.left
                top: isDelta ? undefined : parent.top

            }

            width: isDelta ? (viewSystemType.btnWidth) : 892
            height: viewSystemType.btnHeight

            iconUrl: "file:///usr/share/BeaconOS-lib-images/images/Beacon.svg"
            text: qsTr("Beacon Metrics")
            fontPixelSize: isDelta ? 34 : 50

            onClicked: txt => {
                           compHealthDashboardContentContextNav.systemSelected = txt
                       }
        }

        CompHealthContextNavBtn {
            id: navBtnAsset

            anchors{
                left: isDelta ? navBtnBeacon.right : navBtnBeacon.left
                leftMargin: isDelta ? viewSystemType.btnSpacing : 0
                top: isDelta ? undefined : navBtnBeacon.bottom
                topMargin: isDelta ? 0 :viewSystemType.btnSpacing

            }

            width: navBtnBeacon.width
            height: navBtnBeacon.height

            iconUrl: "file:///usr/share/BeaconOS-lib-images/images/AssetFill.svg"
            text: qsTr("Asset Metrics")
            fontPixelSize: isDelta ? 34 : 50

            onClicked: txt => {
                           compHealthDashboardContentContextNav.systemSelected = txt
                       }
        }

        CompHealthContextNavBtn {
            id: navBtnVision

            anchors{
                left: isDelta ? navBtnAsset.right : navBtnBeacon.left
                leftMargin: isDelta ? viewSystemType.btnSpacing : 0
                top : isDelta ? undefined : navBtnAsset.bottom
                topMargin: isDelta ? 0 :viewSystemType.btnSpacing
            }

            width: navBtnBeacon.width
            height: navBtnBeacon.height

            iconUrl: "file:///usr/share/BeaconOS-lib-images/images/CameraFill.svg"
            text: qsTr("Camera Gallery")
            fontPixelSize: isDelta ? 34 : 50

            onClicked: txt => {
                           compHealthDashboardContentContextNav.systemSelected = txt
                       }
        }
    }

    Item {
        id: viewContext1_Beacon
        visible: (parent.systemSelected === "Beacon Metrics" && parent.context1Selected === "null")

        property real btnSpacing: 41
        property real btnWidth: isDelta ? ((compHealthDashboardContentContextNav.width - (btnSpacing * 3)) * 0.5) : 892
        property real btnHeight: 303

        anchors{
            centerIn: parent
        }

        height: childrenRect.height
        width: childrenRect.width

        CompHealthContextNavBtn{

            id:navBtnBeaconEnv
            width: viewContext1_Beacon.btnWidth
            height: viewContext1_Beacon.btnHeight
            iconUrl: "file:///usr/share/BeaconOS-lib-images/images/Environmental.svg"
            text: "Environmental"
            myHierarchyPath: compHealthDashboardContentContextNav.systemSelected + "." + text
            anchors{
                left: parent.left
                topMargin: isDelta ? 0 : 10
            }
            fontPixelSize: isDelta ? 34 : 50

            onClicked: txt => {
                           compHealthDashboardContentContextNav.context1Selected = "ENV"
                       }
        }

        CompHealthContextNavBtn{

            id:navBtnBeaconImu
            width: viewContext1_Beacon.btnWidth
            height: viewContext1_Beacon.btnHeight
            iconUrl: "file:///usr/share/BeaconOS-lib-images/images/IMU.svg"
            text: "IMU"
            myHierarchyPath: compHealthDashboardContentContextNav.systemSelected + "." + text
            anchors{
                left: isDelta ? navBtnBeaconEnv.right : parent.left
                leftMargin: isDelta ? parent.btnSpacing : 0
                top: isDelta ? undefined : navBtnBeaconEnv.bottom
                topMargin: isDelta ? 0 : 52
            }
            fontPixelSize: isDelta ? 34 : 50

            onClicked: txt => {
                           compHealthDashboardContentContextNav.context1Selected = txt
                       }
        }

    }


    Item{
        id: viewContext1_Asset
        visible: (parent.systemSelected === "Asset Metrics" && parent.context1Selected === "null")

        property real btnSpacing: 41
        property real btnHeight: isDelta ? 250 : 303
        property real btnWidth: isDelta ? ((compHealthDashboardContentContextNav.width - (btnSpacing * 3)) * 0.25) : 892
        property int fontPixelSize: isDelta ? (compHealthDashboardContentContextNav.isMaxWidth ? 32 : 24) : 50

        anchors{
            fill: parent
        }

        GridView {
            id: rowDynamicContexts
            clip: true
            boundsBehavior: Flickable.StopAtBounds



            anchors{
                fill: parent
                topMargin: isDelta ? 0 : 20
                leftMargin: isDelta ? 0 : 10
            }

            model: compHealthDashboardContentContextNav.visible ? compHealthDashboardContentContextNav.modelData_Context1 : undefined

            cellWidth: isDelta ? (width * 0.25) : (viewContext1_Asset.btnWidth + viewContext1_Asset.btnSpacing
)
            cellHeight: isDelta ? (viewContext1_Asset.btnHeight * 1.1) : (viewContext1_Asset.btnHeight + viewContext1_Asset.btnSpacing)

            delegate: CompHealthContextNavBtn{
                id: navBtnDelegate
                property var myModel: model
                width: viewContext1_Asset.btnWidth
                height: viewContext1_Asset.btnHeight
                iconUrl:  (text === "?" ) ? "" : ((isMTConnectData ? "" : "file:/usr/share/BeaconOS-lib-images/images/"+ text +".svg"))

                text: compHealthDashboardContentContextNav.getContext1Name(index, model)
                myHierarchyPath: compHealthDashboardContentContextNav.systemSelected + "." + text
                fontPixelSize: viewContext1_Asset.fontPixelSize

                onClicked: function(txt){
                    if(compHealthDashboardContentContextNav.isMTConnectData)
                    {
                        compHealthDashboardContentContextNav.mtcSortFilterString = navBtnDelegate.myModel.name
                    }

                    compHealthDashboardContentContextNav.context1Selected = txt



                }

            }

        }

    }


    Item {
        id: viewContext2
        visible: (parent.context1Selected !== "null" && parent.context2Selected === "null" && parent.systemSelected !== "null")

        anchors{
            fill: parent
            topMargin: isDelta ? 0 : 20
            leftMargin: isDelta ? 0 : 10
        }

        GridView {
            id: gridContext2

            clip: true

            property real cellSpacing: 26
            property real btnWidth: isDelta ? 319 : 892
            property real btnHeight: isDelta ? 133 : 128

            model: compHealthDashboardContentContextNav.visible ? TableModelHealthDashboard.listOfContext2Options : undefined

            delegate:
                CompHealthContextNavBtn{

                text: TableModelHealthDashboard.getContext2Name(index, compHealthDashboardContentContextNav.context1Selected)
                myHierarchyPath: compHealthDashboardContentContextNav.systemSelected + "." + compHealthDashboardContentContextNav.context1Selected + "." + text
                height: gridContext2.btnHeight
                width: gridContext2.btnWidth

                fontPixelSize: isDelta ? 28 : 40

                onClicked: txt => {
                               compHealthDashboardContentContextNav.context2Selected = txt
                           }
            }


            cellHeight: btnHeight + cellSpacing
            cellWidth: btnWidth + cellSpacing


            anchors{
                fill: parent
            }
            ScrollBar.vertical: ScrollBar{
                policy:  ScrollBar.AsNeeded
                width: 8
                //topInset: 51
                topPadding: 51
            }
        }

    }


}
