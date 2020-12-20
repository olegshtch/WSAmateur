#include "serverCardZone.h"

#include <algorithm>
#include <random>
#include <time.h>

ServerCardZone::ServerCardZone(ServerPlayer *player, const std::string_view name, ZoneType type)
    : mPlayer(player), mName(name), mType(type) {}

void ServerCardZone::addCard(std::shared_ptr<CardInfo> info) {
    mCards.emplace_back(std::make_unique<ServerCard>(info, this));
}

void ServerCardZone::addCard(size_t pos) {
    mCards.emplace_back(std::make_unique<ServerCard>(pos, this));
}

ServerCard* ServerCardZone::addCard(std::unique_ptr<ServerCard> card) {
    return mCards.emplace_back(std::move(card)).get();
}

std::unique_ptr<ServerCard> ServerCardZone::swapCards(std::unique_ptr<ServerCard> card, size_t pos) {
    std::swap(mCards[pos], card);
    mCards[pos]->setPos(pos);
    return card;
}

void ServerCardZone::swapCards(size_t pos1, size_t pos2) {
    std::swap(mCards[pos1], mCards[pos2]);
}

void ServerCardZone::shuffle() {
    std::shuffle(mCards.begin(), mCards.end(), std::mt19937((unsigned int)time(0)));
}

std::unique_ptr<ServerCard> ServerCardZone::takeCard(size_t index) {
    if (mCards.size() - 1 < index )
        return {};

    auto card = std::move(mCards[index]);
    mCards.erase(mCards.begin() + index);
    return card;
}

std::unique_ptr<ServerCard> ServerCardZone::takeTopCard() {
    if (!mCards.size())
        return {};

    auto card = std::move(mCards[mCards.size() - 1]);
    mCards.pop_back();
    return card;
}

std::unique_ptr<ServerCard> ServerCardZone::takeCardFromPos(size_t pos) {
    auto card = std::move(mCards[pos]);
    mCards[pos].reset();
    return card;
}

ServerCard *ServerCardZone::card(size_t index) {
    if (index >= mCards.size())
        return nullptr;

    return mCards[index].get();
}

bool ServerCardZone::hasCardWithColor(char color) const {
    for (auto &card: mCards) {
        if (card->color() == color)
            return true;
    }

    return false;
}
