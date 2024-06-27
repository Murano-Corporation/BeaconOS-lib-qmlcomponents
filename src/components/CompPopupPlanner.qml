import QtQuick 2.12
import QtLocation 5.12
import QtPositioning 5.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

Comp__BASE_Popup{
        id: popupPlanner
        popupName: "Planner"

        property bool isSearchVisible: true

        height: 800
        width: 1680

        background: Rectangle{
            radius: 20
            color: "#DD000000"
        }

        property string searchString: "*"
        
        CompCustomisableTextField{
            id: txtfldSearch

            visible: popupPlanner.isSearchVisible

            anchors{
                top: parent.top
                topMargin: 20
                left: parent.left
                leftMargin: 20
                right: comboFilters.visible ? comboFilters.left : parent.right
                rightMargin: 20
            }
            onTextChanged: searchString = text
            height: 60
        }

        CompCombobox {
            id: comboFilters
            visible: popupPlanner.isSearchVisible

            anchors{
                right: btnNewPlan.left
                rightMargin: 20
                top: txtfldSearch.top
                //bottom: compCustomisableTextField.bottom
            }

            height: txtfldSearch.height
            displayText: qsTr("Filters")
            fontPixelSize: 24
        }

        CompBtnBreadcrumb{
            id: btnNewPlan
            visible: popupPlanner.isSearchVisible

            anchors{
                right: parent.right
                rightMargin: 20
                top: txtfldSearch.top
            }
            height: txtfldSearch.height
            text: "New Plan"

            onClicked: {
                console.log("Opening new plan");
                popupPlanner.isSearchVisible = false;
            }
        }

        CompCombobox{
            id: repositoriesComboBox
            visible: !popupPlanner.isSearchVisible

            anchors{
                right: btnBack.visible ? btnBack.left : parent.right
                margins: 20
                top: parent.top
                left: parent.left
            }

            height: 60

            displayText: qsTr("Pick repository")
        }
        CompBtnBreadcrumb{
            id: btnBack
            visible: !popupPlanner.isSearchVisible

            anchors{
                right: parent.right
                rightMargin: 20
                top: repositoriesComboBox.top
            }
            height: txtfldSearch.height
            text: "Back"

            onClicked: {
                console.log("Closing new plan");
                popupPlanner.isSearchVisible = true;
            }
        }


        CompBtnBreadcrumb{
            id: btnClose

            anchors{
                bottom: parent.bottom
                right: parent.right
                margins: 20
            }

            text: "Close"
            height: 60
            width: 100

            onClicked: popupPlanner.close()
        }
    }
