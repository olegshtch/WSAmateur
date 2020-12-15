import QtQuick 2.0

Card {
    id: movingCard
    property string code
    property bool opponent
    property string startZone
    property int startId: 0
    property string targetZone
    property int targetId: 0
    signal moveFinished()

    property real toX
    property real toY
    property real toScale

    z: 100

    function startAnimation() {
        let szone = gGame.getZone(startZone, opponent);
        movingCard.x = szone.getXForCard(startId);
        movingCard.y = szone.getYForCard();
        let tzone = gGame.getZone(targetZone, opponent);
        toX = tzone.getXForNewCard();
        toY = tzone.getYForNewCard();
        toScale = tzone.scale;
        if (targetZone === "clock")
            movingCard.transformOrigin = Item.TopLeft;
        if ((startZone === "hand" && targetZone === "wr")
            || (startZone === "hand" && targetZone === "clock")) {
            straightMove.start();
        } else if(startZone === "deck" && targetZone === "hand") {
            if (opponent)
                straightMove.start();
            else
                deckReveal.start();
        }
    }

    function finishMove() {
        var zone = gGame.getZone(targetZone, opponent);
        zone.addCard(code);
        gGame.actionComplete();
        moveFinished();
    }

    transform: Rotation {
        id: yRot
        origin.x: movingCard.width / 2
        origin.y: movingCard.height / 2
        angle: 0
        axis { x: 0; y: 1; z: 0 }
    }

    SequentialAnimation {
        id: straightMove
        ParallelAnimation {
            NumberAnimation { target: movingCard; property: "x"; to: toX; duration: 300; }
            NumberAnimation { target: movingCard; property: "y"; to: toY; duration: 300; }
            NumberAnimation { target: movingCard; property: "scale"; to: toScale; duration: 300; }
        }
        ScriptAction { script: finishMove() }
    }

    ParallelAnimation {
        id: deckReveal
        NumberAnimation { target: movingCard; property: "x"; to: root.width * (opponent ? 0.2 : 0.75); duration: 200 }
        NumberAnimation { target: movingCard; property: "y"; to: root.height * (opponent ? 0.25 : 0.6); duration: 200 }
        SequentialAnimation {
            NumberAnimation { target: yRot; property: "angle"; from: 0; to: 90; duration: 100; }
            PropertyAction { target: movingCard; property: "source"; value: "image://imgprov/" + code }
            NumberAnimation { target: yRot; property: "angle"; from: -90; to: 0; duration: 100; }
            PauseAnimation { duration: 300 }
        }
        onStopped: {
            if (targetZone === "hand")
                toHandAnim.start();
            else if (targetZone === "stock")
                toStockAnim.start();
        }
    }
    SequentialAnimation {
        id: toHandAnim
        ParallelAnimation {
            NumberAnimation { target: movingCard; property: "x"; to: toX; duration: 200 }
            NumberAnimation { target: movingCard; property: "y"; to: toY; duration: 200 }
            //onStopped: finishMove()
        }
        ScriptAction { script: finishMove() }
    }
}
