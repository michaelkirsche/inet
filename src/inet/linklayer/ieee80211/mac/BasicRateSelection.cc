//
// Copyright (C) 2015 Andras Varga
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see http://www.gnu.org/licenses/.
//
// Author: Andras Varga
//

#include "BasicRateSelection.h"
#include "IRateControl.h"
#include "inet/physicallayer/ieee80211/mode/IIeee80211Mode.h"
#include "inet/physicallayer/ieee80211/mode/Ieee80211ModeSet.h"

#include <stdlib.h>
#include <string.h>

#include "inet/linklayer/ieee80211/mac/MacUtils.h"

namespace inet {
namespace ieee80211 {

Define_Module(BasicRateSelection);

BasicRateSelection::BasicRateSelection()
{
}

void BasicRateSelection::initialize()
{
    modeSet = Ieee80211ModeSet::getModeSet(par("modeSet").stringValue());

    double controlBitrate = par("controlBitrate");
    controlFrameMode = (controlBitrate == -1) ? modeSet->getSlowestMandatoryMode() : modeSet->getMode(bps(controlBitrate));

    double multicastBitrate = par("multicastBitrate");
    multicastFrameMode = (multicastBitrate == -1) ? modeSet->getFastestMandatoryMode() : modeSet->getMode(bps(multicastBitrate));

    double dataBitrate = par("dataBitrate");
    dataFrameMode = (dataBitrate == -1) ? modeSet->getFastestMode() : modeSet->getMode(bps(dataBitrate));

    slowestMandatoryMode = modeSet->getSlowestMandatoryMode();
}

void BasicRateSelection::setRateControl(IRateControl *rateControl)
{
    this->rateControl = rateControl;
    if (rateControl)
        rateControl->initialize(modeSet, dataFrameMode);
}

const IIeee80211Mode *BasicRateSelection::getSlowestMandatoryMode()
{
    return slowestMandatoryMode;
}

const IIeee80211Mode *BasicRateSelection::getModeForUnicastDataOrMgmtFrame(Ieee80211DataOrMgmtFrame *frame)
{
    return rateControl ? rateControl->getRate() : dataFrameMode;
}

const IIeee80211Mode *BasicRateSelection::getModeForMulticastDataOrMgmtFrame(Ieee80211DataOrMgmtFrame *frame)
{
    return multicastFrameMode;
}

const IIeee80211Mode *BasicRateSelection::getModeForControlFrame(Ieee80211DataOrMgmtFrame *dataFrame, Ieee80211Frame *controlFrame)
{
    if (dynamic_cast<Ieee80211ACKFrame *>(controlFrame) && dataFrame != nullptr) {
        auto controlInfo = check_and_cast<Ieee80211ReceptionIndication *>(dataFrame->getControlInfo());
        auto dataMode = controlInfo->getMode();
        auto ackMode = modeSet->getIsMandatory(dataMode) ? dataMode : modeSet->getSlowerMandatoryMode(dataMode);
        return ackMode != nullptr ? ackMode : controlFrameMode;
    }
    else
        return controlFrameMode;
}

const IIeee80211Mode *BasicRateSelection::getResponseControlFrameMode(Ieee80211Frame *frame)
{
    if (frame != nullptr) {
        auto controlInfo = check_and_cast<Ieee80211TransmissionRequest *>(frame->getControlInfo());
        auto frameMode = controlInfo->getMode();
        auto responseMode = modeSet->getIsMandatory(frameMode) ? frameMode : modeSet->getSlowerMandatoryMode(controlInfo->getMode());
        return responseMode != nullptr ? responseMode : controlFrameMode;
    }
    else
        return controlFrameMode;
}

} // namespace ieee80211
} // namespace inet
