import QtQuick 2.12

Comp__BASE {
    id: compEmployeeInfoViewer

    property string employeeNameToSearch: ""
    property alias info: infoItem
    readonly property int rowSpacing_Info: 64
    readonly property int columnSpacing_Section: 40
    readonly property int columnSpacing_Global: 10

    height: colContents.childrenRect.height + (2 * colContents.anchors.margins)
    width: colContents.childrenRect.width + (2 * colContents.anchors.margins)

    onEmployeeNameToSearchChanged: {
        DatabaseController.getGalleryEmployeeInfo(employeeNameToSearch)
    }

    Connections {
        target: DatabaseController

        function onSignal_EmployeeInfoStructCreated(strEmployeeInfo) {

            infoItem.firstName = strEmployeeInfo.sFirstName
            infoItem.middleName = strEmployeeInfo.sMiddleName
            infoItem.lastName = strEmployeeInfo.sLastName

            infoItem.companyCode = strEmployeeInfo.sCompanyCode
            infoItem.contractDuration = strEmployeeInfo.sContractDuration
            infoItem.countryOfBirth = strEmployeeInfo.sCountryOfBirth
            infoItem.dateOfBirth = strEmployeeInfo.sDateOfBirth
            infoItem.dateRecordCreated = strEmployeeInfo.sDateRecordCreated
            infoItem.deletionIndicator = strEmployeeInfo.sDeletionIndicator
            infoItem.employeeId = strEmployeeInfo.sEmployeeNumber
            infoItem.employeeStatus = strEmployeeInfo.sEmployeeStatus
            infoItem.employeeType = strEmployeeInfo.sEmployeeType
            infoItem.firstName = strEmployeeInfo.sFirstName
            infoItem.laborUnion = strEmployeeInfo.sLaborUnion
            infoItem.laborUnionMember = strEmployeeInfo.sLaborMember
            infoItem.languageKey = strEmployeeInfo.sLanguageKey
            infoItem.lastName = strEmployeeInfo.sLastName
            infoItem.middleName = strEmployeeInfo.sMiddleName
            infoItem.photoDate = strEmployeeInfo.sPhotoDate
            infoItem.placeOfBirth = strEmployeeInfo.sPlaceOfBirth
            infoItem.recordCreator = strEmployeeInfo.sRecordCreator
            infoItem.sex = strEmployeeInfo.sSex
            infoItem.stateOrProvinceOfBirth = strEmployeeInfo.sStateOrProvinceOfBirth
            infoItem.timeZoneForRecordCreation = strEmployeeInfo.sTimeZoneForRecordCreation

            console.log("First name is: " + infoItem.firstName)
        }
    }

    Rectangle {
        anchors.fill: parent
    }

    Item {
        id: infoItem

        //PERSONAL INFO
        property string firstName: "---"
        property string middleName: "---"
        property string lastName: "---"

        //DEMOGRAPHIC INFO
        property string sex: "---"
        property string dateOfBirth: "---"
        property string countryOfBirth: "---"
        property string placeOfBirth: "---"
        property string stateOrProvinceOfBirth: "---"
        property string languageKey: "---"

        //EMPLOYEE INFO
        property string employeeId: "---"
        property string employeeStatus: "---"
        property string employeeType: "---"
        property string photoDate: "---"

        //WORK INFO
        property string companyCode: "---"
        property string contractDuration: "---"
        property string laborUnion: "---"
        property string laborUnionMember: "---"

        //RECORD INFO
        property string recordCreator: "---"
        property string dateRecordCreated: "---"
        property string timeZoneForRecordCreation: "---"
        property string deletionIndicator: "---"
    }

    Column {
        id: colContents
        spacing: compEmployeeInfoViewer.columnSpacing_Global
        anchors {
            top: parent.top
            left: parent.left
            margins: 10
        }

        CompSectionLabel {
            text: "Personal"
        }
        Row {
            id: rowPersonalInfoName

            spacing: compEmployeeInfoViewer.rowSpacing_Info

            CompLabelledTextEdit_Vertical {
                id: lblFirstName

                valueText: infoItem.firstName
                headerText: "FIRST"
            }

            CompLabelledTextEdit_Vertical {
                id: lblMiddleName

                valueText: infoItem.middleName
                headerText: "MIDDLE"
            }

            CompLabelledTextEdit_Vertical {
                id: lblLastName

                valueText: infoItem.lastName
                headerText: "last"
            }
        }

        Item {
            height: compEmployeeInfoViewer.columnSpacing_Section
            width: height
        }

        CompSectionLabel {
            text: "Demographics"
        }
        Row {
            id: rowPersonalInfoDemographics

            spacing: compEmployeeInfoViewer.rowSpacing_Info

            CompLabelledTextEdit_Vertical {
                id: lblSex

                valueText: infoItem.sex
                headerText: "sex"
            }

            CompLabelledTextEdit_Vertical {
                id: lblDOB

                valueText: infoItem.dateOfBirth
                headerText: "DOB"
            }

            CompLabelledTextEdit_Vertical {
                id: lblCountryOfBirth

                valueText: infoItem.countryOfBirth
                headerText: "COUNTRY"
            }

            CompLabelledTextEdit_Vertical {
                id: lblPlaceOfBirth

                valueText: infoItem.placeOfBirth
                headerText: "PLACE"
            }

            CompLabelledTextEdit_Vertical {
                id: lblProvinceOfBirth

                valueText: infoItem.stateOrProvinceOfBirth
                headerText: "STATE / PROVINCE"
            }
        }

        Item {
            height: compEmployeeInfoViewer.columnSpacing_Section
            width: height
        }

        CompSectionLabel {
            text: "Employee"
        }
        Row {
            id: rowEmploymentInfo

            spacing: compEmployeeInfoViewer.rowSpacing_Info

            CompLabelledTextEdit_Vertical {
                id: lblEmployeeId

                valueText: infoItem.employeeId
                headerText: "ID"
            }

            CompLabelledTextEdit_Vertical {
                id: lblEmployeeStatus

                valueText: infoItem.employeeStatus
                headerText: "STATUS"
            }

            CompLabelledTextEdit_Vertical {
                id: lblEmployeeType

                valueText: infoItem.employeeType
                headerText: "TYPE"
            }

            CompLabelledTextEdit_Vertical {
                id: lblPhotoDate

                valueText: infoItem.photoDate
                headerText: "PHOTO DATE"
            }
        }

        Item {
            height: compEmployeeInfoViewer.columnSpacing_Section
            width: height
        }

        CompSectionLabel {
            text: "Company"
        }
        Row {
            id: rowCompanyInfo

            spacing: compEmployeeInfoViewer.rowSpacing_Info

            CompLabelledTextEdit_Vertical {
                id: lblCompanyCode

                valueText: infoItem.companyCode
                headerText: "COMPANY CODE"
            }

            CompLabelledTextEdit_Vertical {
                id: lblContractDuration

                valueText: infoItem.contractDuration
                headerText: "CONTRACT DURATION"
            }
        }

        Item {
            height: compEmployeeInfoViewer.columnSpacing_Section
            width: height
        }

        CompSectionLabel {
            text: "Labor Union"
        }

        Row {
            id: rowLaborUnionInfo

            spacing: compEmployeeInfoViewer.rowSpacing_Info

            CompLabelledTextEdit_Vertical {
                id: lblLaborUnionMember

                valueText: infoItem.laborUnionMember
                headerText: "LABOR UNION MEMBER"
            }

            CompLabelledTextEdit_Vertical {
                id: lblLaborUnion

                valueText: infoItem.laborUnion
                headerText: "LABOR UNION"
            }
        }

        Item {
            height: compEmployeeInfoViewer.columnSpacing_Section
            width: height
        }
        CompSectionLabel {
            text: "Record"
        }
        CompLabel {
            id: lblDeletion

            text: "Deletion: " + infoItem.deletionIndicator

            font: lblFirstName.headerObject.font
            color: lblFirstName.headerObject.color
        }

        CompLabel {
            id: lblRecordCreationInfo

            readonly property string fullText: "Record created by '" + infoItem.recordCreator
                                               + "' on '" + infoItem.dateRecordCreated + " ("
                                               + infoItem.timeZoneForRecordCreation + ")'"

            text: lblRecordCreationInfo.fullText

            font: lblFirstName.headerObject.font
            color: lblFirstName.headerObject.color
        }
        Item {
            height: compEmployeeInfoViewer.columnSpacing_Section
            width: height
        }
    }
}
