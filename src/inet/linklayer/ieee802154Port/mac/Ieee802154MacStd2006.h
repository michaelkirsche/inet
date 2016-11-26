//
// Copyright (C) 2016   Michael Kirsche
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

#ifndef INET_LINKLAYER_IEEE802154PORT_MAC_IEEE802154MACSTD2006_H_
#define INET_LINKLAYER_IEEE802154PORT_MAC_IEEE802154MACSTD2006_H_

#include "inet/common/INETDefs.h"
#include "inet/linklayer/ieee802154Port/mac/Ieee802154MacBase.h"

namespace inet {
namespace ieee802154Port {

/**
 * Implements the IEEE 802.15.4 MAC from the 2006 standard revision.
 */
class INET_API Ieee802154MacStd2006 : public Ieee802154MacBase
{
    public:
        Ieee802154MacStd2006();
        virtual ~Ieee802154MacStd2006();
};

} /* namespace ieee802154Port */
} /* namespace inet */

#endif /* INET_LINKLAYER_IEEE802154PORT_MAC_IEEE802154MACSTD2006_H_ */
