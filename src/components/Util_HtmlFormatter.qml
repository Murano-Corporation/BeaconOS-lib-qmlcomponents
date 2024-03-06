import QtQuick 2.12
import QtQuick.Controls 2.12

Comp__BASE {
    id: utilhtmlFormatter

    property string htmlTextDecorators_Pre: '<html>
        <head><style>
        h1 { color: #9287ED; font-size: xx-large; text-transform: uppercase }
        h2 { color: #9287ED; font-size: x-large; text-transform: uppercase }
        h3 { color: #9287ED; font-size: large; text-transform: uppercase }
        h4 { color: #9287ED; font-size: medium; text-transform: uppercase }
        p { color: white; font-size: x-large;}
        ol {color: #80ffffff;}
        li {color: #80ffffff; text-indent: 0px; font-size: x-large;}
        a {color: "#9287ED"; font-size: x-large;}
        table, th, td {
            border: 1px solid green;
        }
        .test {background-color: white; }
        </style></head>'

    property string htmlTextDecorators_Post: '</html>'
}
