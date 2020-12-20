import QtQuick 2.12
import QtQuick.Window 2.12

import wsamateur.cardModel 1.0

ListView {
    id: clockView

    property bool opponent
    property bool hidden: false
    property CardModel mModel: innerModel
    property real mMarginModifier: 0.3
    property real mMargin: root.cardWidth * mMarginModifier
    property real mScale: 0.7

    x: {
        if (opponent)
            return root.width * 0.7;
        else
            return root.width * 0.08;
    }
    y: {
        if (opponent)
            return -root.height * 0.01;
        else
            return root.height * 0.85;
    }
    width: contentWidth
    height: root.cardHeight
    spacing: -root.cardWidth * (1 - mMarginModifier)
    orientation: ListView.Horizontal
    interactive: false

    model: mModel

    delegate: Component {
        MouseArea {
            id: cardDelegate

            width: root.cardWidth
            height: root.cardHeight
            hoverEnabled: true
            scale: mScale

            onEntered: {
                cardImgDelegate.state = "hovered";
            }
            onExited: {
                cardImgDelegate.state = "";
            }

            Card {
                id: cardImgDelegate

                property CardInfoFrame cardTextFrame: null

                mSource: model.code;
                anchors.centerIn: cardDelegate

                states: State {
                    name: "hovered"
                    PropertyChanges {
                        target: cardImgDelegate
                        z: 100
                    }
                    ParentChange {
                        target: cardImgDelegate
                        parent: clockView.contentItem
                        scale: 0.8
                    }
                    StateChangeScript {
                        name: "textFrame"
                        script: createTextFrame(cardImgDelegate);
                    }
                }

                transitions: Transition {
                    from: "hovered"
                    to: ""
                    ScriptAction { script: destroyTextFrame(cardImgDelegate); }
                }
            }
        }
    }

    function createTextFrame(frameParent) {
        let comp = Qt.createComponent("CardInfoFrame.qml");
        let incubator = comp.incubateObject(root, { visible: false }, Qt.Asynchronous);
        let createdCallback = function(status) {
            if (status === Component.Ready) {
                if (frameParent.state !== "hovered") {
                    incubator.object.destroy();
                    return;
                }
                if (frameParent.cardTextFrame !== null)
                    frameParent.cardTextFrame.destroy();
                var textFrame = incubator.object;

                let cardMappedPoint = root.mapFromItem(frameParent, frameParent.x, frameParent.y);
                let cardOffset = frameParent.x * clockView.scale;

                if (!opponent) {
                    let cardWidthAndScaleOffset = frameParent.width * clockView.scale * (frameParent.scale + 1) / 2;
                    textFrame.x = clockView.x + cardOffset + cardWidthAndScaleOffset;
                    textFrame.y = cardMappedPoint.y;

                    let cardHeight = frameParent.height * clockView.scale * frameParent.scale;
                    if (textFrame.height > cardHeight)
                        textFrame.y -= textFrame.height - cardHeight;
                } else {
                    textFrame.x = clockView.x - textFrame.width + cardOffset;
                    textFrame.y = cardMappedPoint.y;
                }

                textFrame.visible = true;
                frameParent.cardTextFrame = textFrame;
            }
        }
        if (incubator.status !== Component.Ready) {
            incubator.onStatusChanged = createdCallback;
        } else {
            createdCallback(Component.Ready);
        }
    }

    function destroyTextFrame(frameParent) {
        if (frameParent.cardTextFrame !== null) {
            frameParent.cardTextFrame.destroy();
            frameParent.cardTextFrame = null;
        }
    }

    function addCard(code) {
        clockView.mModel.addCard(code);
    }
    function getXForNewCard() { return clockView.x + clockView.count * mMargin; }
    function getYForNewCard() { return clockView.y; }
    function getXForCard() { return clockView.x + (clockView.count ? (clockView.count - 1) : 0) * mMargin; }
    function getYForCard() { return clockView.y; }
    function scaleForMovingCard() { return mScale; }
}
