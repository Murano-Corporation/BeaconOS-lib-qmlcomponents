import QtQuick 2.12

Screen__BASE {
    id: screenAssetDashboardRoot
    anchors.fill: parent

    screenName: "Asset Dashboard"

    property string selectedAssetType: ""
    property string selectedViewMode: "Grid"
    property string searchString: "*"
    property var listOfAssets
    property var listOfAssetTypes: Settings.listOfAssetTypes

    property real selectedAssetLabelX: 0
    property real selectAssetLabelWidth: 200

    property bool hasCncAssets: false
    property bool hasLatheAssets: false
    property bool hasVehicleAssets: false
    property bool hasGeneratorAssets: false
    property bool hasAnyAssets: false


    onSelectedAssetTypeChanged: {
        TableModelAssetDashboardGridView.slot_SetFilter_Type(selectedAssetType);
    }

    onSearchStringChanged: {
        TableModelAssetDashboardGridView.slot_SetFilter_String(searchString);
    }

    Component.onCompleted: {

        ///TODO - CHANGE THIS TO HAPPEN IN TOPIC BEACON ID OBJECT


        lblAllAssets.clicked()
        MqttTopicHealth.slot_Unsubscribe();
        MqttTopicBeaconIdDict.slot_Subscribe();
        MqttTopicBeaconIdDict.slot_UpdateBeaconIdModelFilters();


    }

    Item{
        id: groupTopControls

        //width: isDelta ? 1800 : width

        anchors{
            top: parent.top
            topMargin: isDelta ? 0 : 150
            left: parent.left
            leftMargin: 10
            right: parent.right
            rightMargin: 10
            //horizontalCenter: parent.horizontalCenter
        }

        height: isDelta ? lblScreenName.height : 100


        CompLabel {
            id: lblScreenName

            anchors{
                top: parent.top
                left: parent.left
            }

            font.pixelSize: 50
        }

        CompCustomisableTextField {
            id: compCustomisableTextField

            anchors{
                left: isDelta ? lblScreenName.right : parent.left
                leftMargin: isDelta ? 181 : 0
                //bottom: lblScreenName.bottom
                top: isDelta ? parent.top : lblScreenName.bottom
                topMargin: isDelta ? 0 : 20
                right: isDelta ? ((comboFilters.visible ? comboFilters.left : (comboSort.visible ? comboSort.left : (btnGridView.visible ? btnGridView.left : (btnListView.visible ? btnListView.left : (btnMapView.visible ? btnMapView.left : parent.right)))))) : parent.right
                //right: parent.right
                rightMargin: 20
            }

            height: groupTopControls.height

            textFontSize: isDelta ? 20 : 40
            btnClearSize: isDelta ? 23 : 60

            onTextChanged: searchString = text

        }

        CompCombobox {
            id: comboFilters

            anchors{
                left: isDelta ? undefined : compCustomisableTextField.left
                leftMargin: isDelta ? 20 : 0
                right: comboSort.left
                rightMargin: 20
                top: isDelta ? compCustomisableTextField.top : compCustomisableTextField.bottom
                topMargin: isDelta ? 0 : 20
                //bottom: compCustomisableTextField.bottom
            }

            height: compCustomisableTextField.height
            displayText: qsTr("Filters")
            fontPixelSize: isDelta ? 24 : 40
        }

        CompCombobox {
            id: comboSort

            anchors{
                right: btnGridView.left
                rightMargin: 20
                bottom: comboFilters.bottom
                top: comboFilters.top
            }

            displayText: qsTr("Sort")

        }

        CompIconBtn {
            id: btnGridView

            anchors{
                verticalCenter: btnListView.verticalCenter
                right: btnListView.left
                rightMargin: 20
            }

            iconColor: (selectedViewMode === "Grid") ? "White" : "#80ffffff"
            iconUrl: "file:///usr/share/BeaconOS-lib-images/images/GridFill.svg"
            height: btnMapView.height

            onClicked: selectedViewMode = "Grid"
        }

        CompIconBtn {
            id: btnListView

            enabled: false

            anchors{
                rightMargin: 20
                right: btnMapView.left
                verticalCenter: btnMapView.verticalCenter
            }

            iconColor: (selectedViewMode === "List") ? "White" : "#80ffffff"
            iconUrl: "file:///usr/share/BeaconOS-lib-images/images/ListFill.svg"
            height: btnMapView.height

            onClicked: selectedViewMode = "List"
        }

        CompIconBtn {
            id: btnMapView

            enabled: true

            anchors.verticalCenter: comboSort.verticalCenter

            anchors.right: parent.right

            iconColor: (selectedViewMode === "Map") ? "White" : "#80ffffff"
            iconUrl: "file:///usr/share/BeaconOS-lib-images/images/MapFill.svg"
            height: isDelta ? 40 : groupTopControls.height

            onClicked: selectedViewMode = "Map"
        }





    }


    Rectangle {
        id: contentBG

        anchors{
            top: groupTopControls.bottom
            topMargin: isDelta ? 40 : 225
            left: groupTopControls.left
            right: groupTopControls.right
            bottom: parent.bottom
            bottomMargin: 56
        }

        color: "#14818087"
        radius: 17
        Row {
            id: rowAssetTypes

            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.right: parent.right

            height: 42

            spacing: 68

            CompLabel {
                id: lblAllAssets
                //enabled: hasAnyAssets
                text: qsTr("All Assets")
                color: selectedAssetType === text ? "White" : "#80ffffff"
                font{
                    pixelSize: 35
                }

                function clicked(){
                    selectedAssetType = text
                    selectAssetLabelWidth = width
                    selectedAssetLabelX = x
                }

                MouseArea {
                    id: mouseareaAllAssets
                    anchors.fill: parent
                    onClicked: {
                        parent.clicked()
                    }
                }
            }

            Repeater{
                id: rptAssetTypeButtons

                model: screenAssetDashboardRoot.listOfAssetTypes

                CompLabel {
                    id: lblDieselGenerators
                    //enabled: hasGeneratorAssets
                    text: modelData
                    color: screenAssetDashboardRoot.selectedAssetType === text ? "White" : "#80ffffff"

                    font{
                        pixelSize: 35
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            screenAssetDashboardRoot.selectedAssetType = parent.text
                            screenAssetDashboardRoot.selectAssetLabelWidth = parent.width
                            screenAssetDashboardRoot.selectedAssetLabelX = parent.x
                        }
                    }
                }
            }

        }

        Rectangle{
            id: assetUnderscoreBg

            anchors.top: rowAssetTypes.bottom
            anchors.topMargin: 24
            anchors.left: parent.left
            anchors.right: parent.right

            height: 6

            color: "#4D4A5F"


        }

        Rectangle {
            id: assetUnderscoreSelector

            anchors.verticalCenter: assetUnderscoreBg.verticalCenter

            height: 6
            radius: 3
            color: "#80FFFFFF"

            x: (rowAssetTypes.anchors.leftMargin -10) + (selectedAssetLabelX)
            width: (20) + (selectAssetLabelWidth)

        }

        Loader{
            id: ldrTableView

            active: screenAssetDashboardRoot.selectedViewMode === "List"

            anchors.top: assetUnderscoreBg.bottom
            anchors.topMargin: 40
            anchors.left: parent.left
            anchors.leftMargin: 40
            anchors.rightMargin: 40
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 40

            sourceComponent: TableView{
                id: tableView

                boundsBehavior: Flickable.StopAtBounds

                clip: true

                model: TableModelAssetDashboardGridView

                delegate: CompLabel{
                    text: model.display

                    font{
                        pixelSize: 16
                    }
                }
            }

        }


        Loader{
            id: ldrGridView

            active: screenAssetDashboardRoot.selectedViewMode === "Grid"

            anchors.top: ldrTableView.top
            anchors.left: ldrTableView.left
            anchors.leftMargin: isDelta ? 0 : 40
            anchors.right: isDelta ? ldrTableView.right : parent.right
            anchors.bottom: ldrTableView.bottom

            sourceComponent: GridView {
                id: gridView

                boundsBehavior: Flickable.StopAtBounds

                clip: true

                model: TableModelAssetDashboardGridView


                cellWidth: isDelta ? ((width - leftMargin) * 0.25) : 480
                cellHeight: isDelta ? (368 + 46) : 480

                delegate: CompAssetDashboardGridItem{

                    assetName: model.asset_name
                    //assetState: modelData.Asset_Status
                    beaconID: model.Beacon_ID
                    beaconState: model.status
                    assetType: model.asset_type

                }

            }

        }


        Loader{
            id: ldrMapView
            active: screenAssetDashboardRoot.selectedViewMode === "Map"

            anchors{
                fill: ldrTableView
            }

            sourceComponent: CompAssetMapView {
                id: compAssetMapView


            }


        }


    }



}
