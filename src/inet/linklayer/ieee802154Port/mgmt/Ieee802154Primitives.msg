//
// Copyright (C) 2016 Sebastian Boehm (adapted from old INET 2.x IEEE 802.15.4-2003/2006 model) 
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

cplusplus {{
#include "inet/linklayer/common/MACAddress.h"
#include "inet/linklayer/ieee802154Port/mac/Ieee802154Frame_m.h"
}}

class noncobject MACAddress;
class noncobject SuperframeSpec;
class noncobject DevCapability;
class noncobject PendingAddrFields;

enum Ieee802154AddrMode;
enum Ieee802154AssociationStatus;
enum Ieee802154DisassociateReason;

namespace inet::ieee802154Port;

// --------------------------------------------------------------------------------------
// enum's and struct's for message fields and values
// --------------------------------------------------------------------------------------

// errors in security processing (Table 55 - IEEE 802.15.4-2006, Table 8-12 - IEEE 802.15.4-2015)
enum Ieee802154SecuFail
{
    SECURITY_SUCCESS		= 0x00;
	COUNTER_ERROR			= 0x01;
	IMPROPER_KEY_TYPE		= 0x02;
	IMPROPER_SECURITY_LEVEL	= 0x03;
	SECURITY_ERROR			= 0x04;
	UNAVAILABLE_KEY			= 0x05;
	UNSUPPORTED_LEGACY		= 0x06;
	UNSUPPORTED_SECURITY	= 0x07;
};

// MAC enumerations description (Table 78 - IEEE 802.15.4-2006, ??? - IEEE 802.15.4-2015)
enum IeeeMACEnumeration {
    // enum Ieee802154AssociationStatus
    mac_SUCCESS					= 0x00;	// TODO: merge Ieee802154AssociationStatus with IeeeMACEnumeration? 
    mac_PAN_AT_CAPACITY			= 0x01;
    mac_PAN_ACCESS_DENIED		= 0x02;
    //--------------------------------

    mac_BEACON_LOSS 			= 0xe0;
    mac_CHANNEL_ACCESS_FAILURE 	= 0xe1;
    mac_COUNTER_ERROR 			= 0xdb;
    mac_DENIED 					= 0xe2;
    mac_DISABLE_TRX_FAILURE 	= 0xe3;
    mac_FRAME_TOO_LONG 			= 0xe5;
    mac_IMPROPER_KEY_TYPE 		= 0xdc;
    mac_IMPROPER_SECURITY_LEVEL	= 0xdd;
    mac_INVALID_ADDRESS 		= 0xf5;
    mac_INVALID_GTS 			= 0xe6;
    mac_INVALID_HANDLE 			= 0xe7;
    mac_INVALID_INDEX 			= 0xf9;
    mac_INVALID_PARAMETER 		= 0xe8;
    mac_LIMIT_REACHED 			= 0xfa;
    mac_NO_ACK 					= 0xe9;
    mac_NO_BEACON 				= 0xea;
    mac_NO_DATA 				= 0xeb;
    mac_NO_SHORT_ADDRESS 		= 0xec;
    mac_ON_TIME_TOO_LONG 		= 0xf6;
    mac_OUT_OF_CAP 				= 0xed;
    mac_PAN_ID_CONFLICT 		= 0xee;
    mac_PAST_TIME 				= 0xf7;
    mac_READ_ONLY 				= 0xfb;
    mac_REALIGNMENT 			= 0xef;
    mac_SCAN_IN_PROGRESS 		= 0xfc;
    mac_SECURITY_ERROR 			= 0xe4;
    mac_SUPERFRAME_OVERLAP 		= 0xfd;
    mac_TRACKING_OFF 			= 0xf8;
    mac_TRANSACTION_EXPIRED 	= 0xf0;
    mac_TRANSACTION_OVERFLOW 	= 0xf1;
    mac_TX_ACTIVE 				= 0xf2;
    mac_UNAVAILABLE_KEY 		= 0xf3;
    mac_UNSUPPORTED_ATTRIBUTE 	= 0xf4;
    mac_UNSUPPORTED_LEGACY 		= 0xde;
    mac_UNSUPPORTED_SECURITY 	= 0xdf;
    mac_UNDEFINED				= 0xff;	// TODO: added this for handling any case not specified in the standard
};

enum Ieee802154Attributes {
    currentChannel      = 0;
    channelSupported    = 1;
    transmitPower       = 2;
    CCA_Mode            = 3;
    currentPage         = 4;
    SHRduration         = 5;
    symbolsPerSecond    = 6;
};

enum Ieee802154PhyPIBStatus {
    PhyPIB_SUCCESS                  = 10;
    PhyPIB_UNSUPPORTED_ATTRIBUTE    = 11;
    PhyPIB_INVALID_PARAMETER        = 12;
    PhyPIB_READ_ONLY                = 13;
};

// elements of PAN descriptor (Table 55 - IEEE 802.15.4-2006, Table 8-12 - IEEE 802.15.4-2015)
struct PANElements
{
        unsigned char CoordAddrMode @enum(Ieee802154AddrMode);	// coordinator addressing mode
        unsigned short CoordPANId;								// PAN identifier of the coordinator
        MACAddress CoordAddress;      							// as specified by CoordAddrMode
        unsigned char ChannelNumber;							// current logical channel
        unsigned char ChannelPage;								// current channel page
        //SuperframeSpec Superframe;     							// ignored, store in txSfSpec or rxSfSpec instead
        bool GTSPermit;										
        unsigned char LinkQuality;
        //simtime_t     TimeStamp;              				// ignored, use bcnRxTime instead
        unsigned char SecurityFailure @enum(Ieee802154SecuFail);
        unsigned char SecurityLevel;
        unsigned char KeyIdMode;
        unsigned long KeySource;
        unsigned char KeyIndex;
        //UINT_16   clusTreeDepth;								// add one field for cluster tree
        
        // 2015 added fields
        // TODO:
};

// --------------------------------------------------------------------------------------
// primitive definitions
// --------------------------------------------------------------------------------------

// MLME-ASSOCIATE.indication (Table 48 - IEEE 802.15.4-2006, Table 8-5 - IEEE 802.15.4-2015)
message Ieee802154Prim_AssociateInd
{
    MACAddress addr;						// used different in request and response for coordinator // device addr
    DevCapability CapabilityInformation;
    unsigned char SecurityLevel;            // 0x00–0x07, compare Table 95 in Spec. 802.15.4-2006
    unsigned char KeyIdMode;                // 0x00–0x03, mode to identify the key to be used
    unsigned long KeySource;                // depending on KeyidMode max set of uint8_t[8]
    unsigned char KeyIndex;                 // 0x01–0xff, index of the key to be used
    
    // 2015 added fields
    // TODO:   
}

// MLME-ASSOCIATE.request (Table 47 - IEEE 802.15.4-2006, Table 8-4 - IEEE 802.15.4-2015)
message Ieee802154Prim_AssociateReq extends Ieee802154Prim_AssociateInd
{
    unsigned int ChannelNumber;            					// logical channel on which to start using new superframe configuration
    unsigned char ChannelPage;              				// 0 - 31, channel page on which to start using new superframe configuration
    unsigned char CoordAddrMode @enum(Ieee802154AddrMode);
    MACAddress CoordPANId;									// TODO: unsigned short?
    MACAddress CoordAddress;     
}

// MLME-ASSOCIATE.response (Table 49 - IEEE 802.15.4-2006, Table 8-6 - IEEE 802.15.4-2015)
message Ieee802154Prim_AssociateRes extends Ieee802154Prim_AssociateInd
{
    // Short Address ist also stored in the long address
    unsigned short status @enum(Ieee802154AssociationStatus);
}

// MLME-ASSOCIATE.confirm (Table 50 - IEEE 802.15.4-2006, Table 8-7 - IEEE 802.15.4-2015)
message Ieee802154Prim_AssociateConf extends Ieee802154Prim_AssociateInd
{
    // Short Address ist also stored in the long address
    unsigned short status @enum(Ieee802154AssociationStatus);
    
    // 2015 added fields
    // TODO:        
}

// MLME-DISASSOCIATE.indication (Table 52 - IEEE 802.15.4-2006, Table 8-9 - IEEE 802.15.4-2015)
message Ieee802154Prim_DisassociateInd //extends Ieee802154Prim_Disassociate
{
    MACAddress DeviceAddress;
    unsigned char DisassociateReason @enum(Ieee802154DisassociateReason);
    unsigned char SecurityLevel;            // 0x00–0x07, compare Table 95 in Spec. 802.15.4-2006
    unsigned char KeyIdMode;                // 0x00–0x03, mode to identify the key to be used
    unsigned long KeySource;                // depending on KeyidMode max set of uint8_t[8]
    unsigned char KeyIndex;                 // 0x01–0xff, index of the key to be used
}

// MLME-DISASSOCIATE.request (Table 51 - IEEE 802.15.4-2006, Table 8-8 - IEEE 802.15.4-2015)
message Ieee802154Prim_DisssociateReq extends Ieee802154Prim_DisassociateInd
{
    unsigned char DeviceAddrMode @enum(Ieee802154AddrMode);   // refer to IEEE802154Enum.h
    unsigned short DevicePANId;
    bool TxIndirect;
}

// MLME-ASSOCIATE.confirm (Table 53 - IEEE 802.15.4-2006, Table 8-10 - IEEE 802.15.4-2015)
message Ieee802154Prim_DisassociateConf
{
    MACAddress DeviceAddress;
    unsigned char DeviceAddrMode @enum(Ieee802154AddrMode);
    unsigned short DevicePANId;
    unsigned short status @enum(IeeeMACEnumeration);
}

// MLME-BEACON-NOTIFY.indication (Table 54 - IEEE 802.15.4-2006, Table 8-11 - IEEE 802.15.4-2015)
message Ieee802154Prim_BeaconNotify
{    
    // SDU is encapsulated					// TODO: no SDU encapsulation in Rev 2015
    unsigned char BSN;                      // 0x00–0xff, beacon sequence number
    PANElements PANDescriptor;              // the PANDescriptor for the received beacon
    PendingAddrFields PendAddrSpec;         // includes numLong numShort and List
    unsigned char sduLength;                // 0 – aMaxBeaconPayloadLength (52) (which is aMaxPHYPacketSize (127) – aMaxBeaconOverhead (75))
    
    // 2015 added fields
    // TODO:
}

// MLME-GET.request (Table 56 - IEEE 802.15.4-2006, Table 8-15 - IEEE 802.15.4-2015)
message Ieee802154Prim_GetRequest
{
    unsigned short PIBattr @enum(Ieee802154Attributes);	// 
    unsigned short PIBind;								// TODO: deleted in Rev 2015
}

// MLME-GET.request (Table 57 - IEEE 802.15.4-2006, Table 8-16 - IEEE 802.15.4-2015)
message Ieee802154Prim_GetConfirm extends Ieee802154Prim_GetRequest
{
    unsigned short status @enum(Ieee802154PhyPIBStatus); //
    double value;
}

// MLME-GTS.request (Table 58 - IEEE 802.15.4-2006, Table 8-19 - IEEE 802.15.4-2015)
