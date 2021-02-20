#include "cardDatabase.h"

CardDatabase::CardDatabase() {
    auto info = std::make_shared<CardInfo>();
    info->setCode("IMC/W43-009");
    info->setLevel(0);
    info->setCost(0);
    info->setSoul(1);
    info->setPower(4000);
    info->setName("prr");
    info->setType(CardType::Char);
    info->setColor('Y');
    info->setTraits({ "Music", "Happy Happy" });
    mDb.emplace(info->code(), info);

    auto info2 = std::make_shared<CardInfo>();
    info2->setCode("IMC/W43-046");
    info2->setLevel(0);
    info2->setCost(0);
    info2->setSoul(1);
    info2->setPower(1500);
    info2->setName("prru");
    info2->setType(CardType::Char);
    info2->setColor('R');
    info2->setTraits({ "Shuchiin" });
    info2->addAbility({0x02, 0x05, 0x00, 0x02, 0x01, 0x01, 0x01, 0x05, 0x01, 0x03, 0x03, 0x03, 0x00, 0x01, 0x01, 0x02, 0x02, 0x01, 0x06, 0x01, 0x02, 0x01, 0x01, 0x03, 0x08, 0x53, 0x68, 0x75, 0x63, 0x68, 0x69, 0x69, 0x6e, 0x01, 0x03, 0x00, 0x01, 0x02, 0x02, 0x01, 0x01, 0x02, 0x01, 0x00, 0x02, 0x00, 0x01, 0x01, 0x01, 0x00, 0x02, 0x01, 0x01, 0xa0, 0x0f, 0x00, 0x00, 0x01});
    info2->addAbility({0x02, 0x05, 0x00, 0x01, 0x02, 0x01, 0x02, 0x02, 0x04, 0x00, 0x01, 0x03, 0x00, 0x01, 0x02, 0x00, 0x01, 0x03, 0x01, 0x01, 0x00, 0x04, 0x01, 0x01, 0x02, 0x01, 0x01, 0x01, 0x05, 0x01, 0x03, 0x01, 0x06, 0x00, 0x04, 0x05, 0x00, 0x01, 0x02, 0x02, 0x01, 0x02, 0x01, 0x01, 0x06, 0x02, 0x02, 0x00, 0x03, 0x01, 0x03, 0x00, 0x02, 0x01, 0x00, 0x04, 0x00, 0x01, 0x02, 0x00, 0x00, 0x01, 0x01, 0x00, 0x05, 0x01, 0x00, 0x24, 0x00, 0x03, 0x01, 0x00});
    mDb.emplace(info2->code(), info2);

    auto info100500 = std::make_shared<CardInfo>();
    info100500->setCode("KGL/S79-055");
    info100500->setLevel(0);
    info100500->setCost(0);
    info100500->setSoul(1);
    info100500->setPower(1500);
    info100500->setName("prru");
    info100500->setType(CardType::Char);
    info100500->setColor('R');
    info100500->setTraits({ "Music" });
    mDb.emplace(info100500->code(), info100500);

    auto info3 = std::make_shared<CardInfo>();
    info3->setCode("IMC/W43-111");
    info3->setLevel(1);
    info3->setCost(0);
    info3->setSoul(1);
    info3->setPower(5000);
    info3->setName("prru");
    info3->setType(CardType::Char);
    info3->setColor('B');
    info3->setTraits({ "Music" });
    mDb.emplace(info3->code(), info3);

    auto info4 = std::make_shared<CardInfo>();
    info4->setCode("IMC/W43-091");
    info4->setLevel(3);
    info4->setCost(2);
    info4->setSoul(2);
    info4->setPower(10000);
    info4->setName("prru");
    info4->setType(CardType::Char);
    info4->setColor('B');
    info4->setTraits({ "Music" });
    info4->setTriggers({ TriggerIcon::Soul });
    mDb.emplace(info4->code(), info4);

    auto info5 = std::make_shared<CardInfo>();
    info5->setCode("IMC/W43-127");
    info5->setLevel(0);
    info5->setCost(0);
    info5->setSoul(0);
    info5->setPower(0);
    info5->setName("prru");
    info5->setType(CardType::Climax);
    info5->setColor('B');
    info5->setTraits({ "Music" });
    info5->setTriggers({ TriggerIcon::Treasure });
    mDb.emplace(info5->code(), info5);
}

CardDatabase& CardDatabase::get() {
    static CardDatabase instance;
    return instance;
}

std::shared_ptr<CardInfo> CardDatabase::getCard(const std::string &code) {
    if (!mDb.count(code))
        return {};

    return mDb.at(code);
}
