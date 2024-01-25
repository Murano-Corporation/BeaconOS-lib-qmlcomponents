import QtQuick 2.12
import QtQuick.Controls 2.12

Item{
    id: compMessageHtml

    property string htmlFilePath: "file:/.ai/responses/ai-response-TEST-Truck_Maintenance-brakes.html"

    property string htmlTextRaw: '<div><h1>h1 styling</h1><h2>h2 styling</h2><h3>h3 styling</h3><h4>h4 styling</h4><p>p styling</p><ol><li>li style test</li><li>li style test</li><li>li style test</li></ol><a href="https://www.w3schools.com">Link style</a></div>'

    Util_HtmlFormatter {
        id: utilhtmlFormatter
    }

    property string htmlTextFinal: utilhtmlFormatter.htmlTextDecorators_Pre + htmlTextRaw + utilhtmlFormatter.htmlTextDecorators_Post

    height: textArea.contentHeight + textArea.anchors.topMargin + textArea.anchors.bottomMargin + 20
    width: 600

    CompGlassRect{}

    TextArea{
        id: textArea

        anchors{
            fill: parent
            margins: 20
        }

        readOnly: true
        textFormat: TextEdit.RichText
        wrapMode: TextArea.WordWrap

        font{
            family: 'Lato'

            weight: Font.Light
        }
        color: "white"
        text: compMessageHtml.htmlTextFinal

        onLinkActivated: function(link){
            console.log("Link activated: " + link)
        }

        onLinkHovered: function(link){
            console.log("Link hovered: " + link)
        }
    }



}

/*##^##
Designer {
    D{i:0;formeditorColor:"#4c4e50";formeditorZoom:0.9;width:600}
}
##^##*/
