import QtQuick 2.12
import QtQuick.Window 2.12

import wsamateur 1.0

ListView {
    id: level

    property bool opponent
    property bool hidden: false
    property CardModel mModel: innerModel
    property real mMarginModifier: 0.2
    property real mMargin: root.cardHeight * mMarginModifier
    property real mScale: 0.8

    x: opponent ? (root.width * 0.85) : (root.width * 0.08)
    y: opponent ? (root.height * 0.15) : (root.height * 0.87 - getLevelHeight())
    width: root.cardWidth
    height: getLevelHeight()
    spacing: -root.cardHeight * (1 - mMarginModifier)
    interactive: false
    rotation: opponent ? 0 : 180

    model: mModel

    delegate: Component {
        MouseArea {
            id: cardDelegate

            width: root.cardWidth
            height: root.cardHeight
            hoverEnabled: true
            scale: mScale
            rotation: 90

            onEntered: {
                cardImgDelegate.state = "hovered";
            }
            onExited: {
                cardImgDelegate.state = "";
            }

            Card {
                id: cardImgDelegate

                property CardTextFrame cardTextFrame: null

                mSource: model.code;
                anchors.centerIn: cardDelegate
                Component.onDestruction: destroyTextFrame(cardImgDelegate)

                states: State {
                    name: "hovered"
                    PropertyChanges {
                        target: cardImgDelegate
                        z: 100
                    }
                    ParentChange {
                        target: cardImgDelegate
                        parent: level.contentItem
                        scale: 0.9
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
        let comp = Qt.createComponent("CardTextFrame.qml");
        let incubator = comp.incubateObject(root, { visible: false }, Qt.Asynchronous);
        let createdCallback = function(status) {
            if (status === Component.Ready) {
                if (frameParent.state !== "hovered") {
                    incubator.object.destroy();
                    return;
                }
                if (frameParent.cardTextFrame !== null)
                    frameParent.cardTextFrame.destroy();
                let textFrame = incubator.object;

                let scaledX = root.cardWidth * (1 - 0.9) / 2;
                let cardMappedPoint = root.mapFromItem(frameParent, frameParent.x, frameParent.y);
                textFrame.x = level.x + scaledX;
                textFrame.y = cardMappedPoint.y;
                if (!opponent) {
                    textFrame.x += (root.cardHeight + root.cardWidth) / 2 * 0.9;
                    textFrame.y -= textFrame.height;
                } else {
                    textFrame.x += -textFrame.width - ((root.cardHeight - root.cardWidth) / 2) * 0.9;
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

    function getLevelHeight()  {
        if (!level.count)
            return 0;
        return (level.count - 1) * mMargin + root.cardHeight;
    }

    function addCard(code) { level.mModel.addCard(code); }
    function removeCard(index) { level.mModel.removeCard(index); }
    function getXForNewCard() { return opponent ? level.x : level.x; }
    function getYForNewCard() {
        if (opponent)
            return level.y + level.count * mMargin;
        return root.height * 0.87 - level.count * mMargin - root.cardHeight;
    }
    function getXForCard() { return level.x; }
    function getYForCard() { return level.y + (level.count ? (level.count - 1) : 0) * mMargin; }
    function scaleForMovingCard() { return level.mScale; }
}
