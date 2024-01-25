import QtQuick 2.12

Item{
    id: compHealthDashboardContentContextNav

    property string systemSelected: "null"
    property string context1Selected: "null"
    property string context2Selected: "null"
    property bool isMaxWidth: true
    property bool isMaxHeight: false

    Component.onCompleted: {

        MqttTopicCmdBOS.slot_Request_Context2Map(AssetInfo.beaconID);

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
        property real btnHeight: 303

        anchors{
            centerIn: parent
        }

        height: childrenRect.height
        width: childrenRect.width

        CompHealthContextNavBtn {
            id: navBtnBeacon

            anchors{
                left: parent.left

            }

            width: (viewSystemType.btnWidth)
            height: viewSystemType.btnHeight

            iconUrl: "file:///usr/share/BeaconOS-lib-images/images/Beacon.svg"
            text: qsTr("Beacon Metrics")

            onClicked: txt => {
                           compHealthDashboardContentContextNav.systemSelected = txt
                       }
        }

        CompHealthContextNavBtn {
            id: navBtnAsset

            anchors{
                left: navBtnBeacon.right
                leftMargin: viewSystemType.btnSpacing

            }

            width: navBtnBeacon.width
            height: navBtnBeacon.height

            iconUrl: "file:///usr/share/BeaconOS-lib-images/images/AssetFill.svg"
            text: qsTr("Asset Metrics")

            onClicked: txt => {
                           compHealthDashboardContentContextNav.systemSelected = txt
                       }
        }

        CompHealthContextNavBtn {
            id: navBtnVision

            anchors{
                left: navBtnAsset.right
                leftMargin: viewSystemType.btnSpacing
            }

            width: navBtnBeacon.width
            height: navBtnBeacon.height

            iconUrl: "file:///usr/share/BeaconOS-lib-images/images/CameraFill.svg"
            text: qsTr("Camera Gallery")

            onClicked: txt => {
                           compHealthDashboardContentContextNav.systemSelected = txt
                       }
        }
    }

    Item {
        id: viewContext1_Beacon
        visible: (parent.systemSelected === "Beacon Metrics" && parent.context1Selected === "null")

        property real btnSpacing: 41
        property real btnWidth: ((compHealthDashboardContentContextNav.width - (btnSpacing * 3)) * 0.5)
        property real btnHeight: 303

        anchors{
            centerIn: parent
        }

        height: childrenRect.height
        width: childrenRect.width

        CompHealthContextNavBtn{

            id:navBtnBeaconImu
            width: viewContext1_Beacon.btnWidth
            height: viewContext1_Beacon.btnHeight
            iconUrl: "file:///usr/share/BeaconOS-lib-images/images/IMU.svg"
            text: "IMU"
            myHierarchyPath: compHealthDashboardContentContextNav.systemSelected + "." + text
            anchors{
                left: parent.left

            }

            onClicked: txt => {
                           compHealthDashboardContentContextNav.context1Selected = txt
                       }
        }

        CompHealthContextNavBtn{

            id:navBtnBeaconEnv
            width: viewContext1_Beacon.btnWidth
            height: navBtnBeaconImu.height
            iconUrl: "file:///usr/share/BeaconOS-lib-images/images/Environmental.svg"
            text: "ENV"
            myHierarchyPath: compHealthDashboardContentContextNav.systemSelected + "." + text
            anchors{
                left: navBtnBeaconImu.right
                leftMargin: parent.btnSpacing

            }

            onClicked: txt => {
                           compHealthDashboardContentContextNav.context1Selected = txt
                       }
        }

    }


    Item{
        id: viewContext1_Asset
        visible: (parent.systemSelected === "Asset Metrics" && parent.context1Selected === "null")

        property real btnSpacing: 41
        property real btnHeight: 250
        property real btnWidth: ((compHealthDashboardContentContextNav.width - (btnSpacing * 3)) * 0.25)
        property int fontPixelSize: (compHealthDashboardContentContextNav.isMaxWidth ? 32 : 24)

        anchors{
            fill: parent
        }

        GridView {
            id: rowDynamicContexts
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            anchors{
                fill: parent
            }

            model: compHealthDashboardContentContextNav.visible ? TableModelHealthDashboard.listOfContext1Options : undefined

            cellWidth: width * 0.25
            cellHeight: viewContext1_Asset.btnHeight * 1.1

            delegate: CompHealthContextNavBtn{

                width: viewContext1_Asset.btnWidth
                height: viewContext1_Asset.btnHeight
                iconUrl:  (text === "?" ) ? "" : "file:/usr/share/BeaconOS-lib-images/images/"+ text +".svg"

                text: TableModelHealthDashboard.getContext1Name(index)
                myHierarchyPath: compHealthDashboardContentContextNav.systemSelected + "." + text
                fontPixelSize: viewContext1_Asset.fontPixelSize

                onClicked: function(txt){
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

        }

        GridView {
            id: gridContext2

            clip: true

            property real cellSpacing: 26
            property real btnWidth: 319
            property real btnHeight: 133

            model: compHealthDashboardContentContextNav.visible ? TableModelHealthDashboard.listOfContext2Options : undefined

            delegate:
                CompHealthContextNavBtn{

                text: TableModelHealthDashboard.getContext2Name(index, compHealthDashboardContentContextNav.context1Selected)
                myHierarchyPath: compHealthDashboardContentContextNav.systemSelected + "." + compHealthDashboardContentContextNav.context1Selected + "." + text
                height: gridContext2.btnHeight
                width: gridContext2.btnWidth

                fontPixelSize: 28

                onClicked: txt => {
                               compHealthDashboardContentContextNav.context2Selected = txt
                           }
            }


            cellHeight: btnHeight + cellSpacing
            cellWidth: btnWidth + cellSpacing


            anchors{
                fill: parent
            }
        }

    }


}
