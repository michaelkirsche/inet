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

//
// Required for MACAddress declarations
//
cplusplus {{
#include "inet/linklayer/common/MACAddress.h"
}}

class noncobject MACAddress;

namespace inet::ieee802154Port;

// --------------------------------------------------------------------------------------
// enum's and struct's for packet fields and values
// --------------------------------------------------------------------------------------

// MAC frame types (Table 79 - IEEE 802.15.4-2006, Table 7-1 - IEEE 802.15.4-2015)
enum Ieee802154FrameType {
    BEACON  		= 0x00;
    DATA    		= 0x01;
    ACK     		= 0x02;
    MAC_COMMAND 	= 0x03;
    
    // 2015 added frame types
    MULTIPURPOSE	= 0x05;
    FRAGMENT		= 0x06;
    EXTENDED		= 0x07;
}

// Extended frame types (Table 7-5 - IEEE 802.15.4-2015)
enum Ieee802154ExtFrameType {
    TIA				= 0x07;
}

// MAC command frames (Table 82 - IEEE 802.15.4-2006, Table 7-49 - IEEE 802.15.4-2015)
enum Ieee802154MacCmdType {
    //Ieee802154_UNDEFINED_CMD              = 0x00;
    Ieee802154_ASSOCIATION_REQUEST          = 0x01;
    Ieee802154_ASSOCIATION_RESPONSE         = 0x02;
    Ieee802154_DISASSOCIATION_NOTIFICATION  = 0x03;
    Ieee802154_DATA_REQUEST                 = 0x04;
    Ieee802154_PANID_CONFLICT_NOTIFICATION  = 0x05;
    Ieee802154_ORPHAN_NOTIFICATION          = 0x06;
    Ieee802154_BEACON_REQUEST               = 0x07;
    Ieee802154_COORDINATOR_REALIGNMENT      = 0x08;
    Ieee802154_GTS_REQUEST                  = 0x09;
    //Ieee802154_POLL_REQUEST                 = 10		// TODO: remove? - not defined in IEEE 802.15.4-2006/2015
    
    // 2015 added command frames
    Ieee802154_TRLE_MANAGEMENT_REQUEST				= 0x0a;
    Ieee802154_TRLE_MANAGEMENT_RESPONSE				= 0x0b;
    Ieee802154_DSME_ASSOCIATION_REQUEST     		= 0x13;
    Ieee802154_DSME_ASSOCIATION_RESPONSE   		 	= 0x14;
    Ieee802154_DSME_GTS_REQUEST             		= 0x15;
    Ieee802154_DSME_GTS_RESPONSE					= 0x16;
    Ieee802154_DSME_GTS_NOTIFY						= 0x17;
    Ieee802154_DSME_INFORMATION_REQUEST				= 0x18;
    Ieee802154_DSME_INFORMATION_RESPONSE			= 0x19;
    Ieee802154_DSME_BEACON_ALLOCATION_NOTIFICATION	= 0x1a;
    Ieee802154_DSME_BEACON_COLLISION_NOTIFICATION	= 0x1b;
    Ieee802154_DSME_LINK_REPORT						= 0x1c;
    Ieee802154_RIT_DATA_REQUEST						= 0x20;
    Ieee802154_DBS_REQUEST							= 0x21;
    Ieee802154_DBS_RESPONSE							= 0x22;
    Ieee802154_RIT_DATA_RESPONSE					= 0x23;
    Ieee802154_VENDOR_SPECIFIC						= 0x24;
}

// MAC addressing modes (Table 80 - IEEE 802.15.4-2006, Table 7-3 - IEEE 802.15.4-2015)
enum Ieee802154AddrMode {
    NONE        = 0x00;
    ADDR_SHORT  = 0x02;     // 16-bit short address
    ADDR_LONG   = 0x03;      // 64-bit extended address
}

// association status field values (Table 83 - IEEE 802.15.4-2006, Table 7-50 - IEEE 802.15.4-2015)
enum Ieee802154AssociationStatus {
    SUCCESS						= 0x00;
    PAN_AT_CAPACITY				= 0x01;
    PAN_ACCESS_DENIED			= 0x02;
    
    // 2015 added values
    HOPPING_SEQU_OFFSET_DUP		= 0x03;
    FAST_ASSOCIATION_SUCCESS	= 0x80;
}

// disassociation reason codes (Table 84 - IEEE 802.15.4-2006, Table 7-51 - IEEE 802.15.4-2015)
enum Ieee802154DisassociateReason {
    COORDINATOR_WISH_LEAVE		= 0x01;
    DEVICE_WISH_LEAVE			= 0x02;
}

// DSME infor type values (Table 7-54 - IEEE 802.15.4-2015)
enum Ieee802154DSMEInfoType {
    TIMESTAMP				= 0x00;
	DSME_SAB_SPECIFICATION	= 0x01;
	DSME_PAN_DESCRIPTOR		= 0x02;
}

// MAC auxiliary security header - security control field (Figure 75 - IEEE 802.15.4-2006, Figure 9-6 - IEEE 802.15.4-2015)
struct SecurityControl
{
        unsigned char Seculevel;
        unsigned char KeyIdMode;
        
        // 2015 added fields
        bool FrameCounterSuppression;
        bool ASNInNonce;
};

// MAC auxiliary security header - key identifier field (Figure 76 - IEEE 802.15.4-2006, Figure 9-7 - IEEE 802.15.4-2015)
struct KeyIdField
{
        unsigned long KeySource;
        unsigned char KeyIndex;
};

// MAC auxiliary security header format (Figure 74 - IEEE 802.15.4-2006, Figure 9-5 - IEEE 802.15.4-2015)
struct Ash
{
        SecurityControl secu;
        unsigned int FrameCount;
        KeyIdField KeyIdentifier;
};

// MAC information element - header field (Figure 7-21 - IEEE 802.15.4-2015)
struct IEHeader
{
    	unsigned char Length;
    	unsigned char ElementID;
    	bool Type;
};

// TODO: enum for IEs Element IDs

// GTS information fields - GTS specification (Figure 48 - IEEE 802.15.4-2006, Figure 7-9 - IEEE 802.15.4-2015)
struct GTSSpecification
{
        unsigned char count;            // number of GTS descriptors
        bool permit;
};

// GTS information fields - GTS list (Figure 50 - IEEE 802.15.4-2006, Figure 7-11 - IEEE 802.15.4-2015)
struct GTSList
{
        unsigned short devShortAddr;    // device short address
        unsigned char startSlot;        // starting slot
        unsigned char length;           // length in slots
};

// GTS information fields (Figure 45 - IEEE 802.15.4-2006, Figure 7-8 - IEEE 802.15.4-2015)
struct GTSFields
{
        GTSSpecification gtsSpec;		// specification
        unsigned char mask;            	// mask of directions (Figure 49 - IEEE 802.15.4-2006, Figure 7-10 - IEEE 802.15.4-2015)
        GTSList gtsList[0];				// TODO: compilation error due to variable GTS list gtsList[]
};

// GTS characteristics field (Figure 65 - IEEE 802.15.4-2006, Figure 7-108 - IEEE 802.15.4-2015)
struct GTSCharacteristics
{
        unsigned char length;
        bool direction;
        bool type;
};

// pending address information fields (Figure 46 - IEEE 802.15.4-2006, Figure 7-12 - IEEE 802.15.4-2015)
struct PendingAddrFields
{
        unsigned char numShortAddr;     // number of short addresses pending
        unsigned char numExtendedAddr;  // number of extended addresses pending
        MACAddress addrList[7];      // pending address list (shared by short/extended addresses)
};

// capability information field (Figure 56 - IEEE 802.15.4-2006, Figure 7-103/110 - IEEE 802.15.4-2015)
struct DevCapability
{
        bool alterPANCoor;				// TODO: removed/reserved in Rev-2015
        bool FFD;						// device type
        MACAddress addr;				// TODO: remove? - not defined in IEEE 802.15.4-2006/2015
        bool powSrc;					// power source
        bool recvOnWhenIdle;			// receiver on when idle
        bool associationType;			// association type (2015 added flag)
        bool secuCapable;				// security capability
        bool alloShortAddr;				// allocate address
        char* hostName;       			// TODO: remove? - only for convenience
};

// superframe specification field (Figure 47 - IEEE 802.15.4-2006, Figure 7-7 - IEEE 802.15.4-2015)
struct SuperframeSpec
{
        unsigned char BO;       // beacon order (0 - 15)
        unsigned int BI;        // beacon interval --> BI = aBaseSuperframeDuration * 2^BO (in symbols)
        unsigned char SO;       // superframe order (0 - 15)
        unsigned int SD;        // superframe duration --> SD = aBaseSuperframeDuration * 2^SO (in symbols)
        unsigned char finalCap; // final superframe slot utilized by the CAP
        bool battLifeExt;       // battery life extension
        bool panCoor;           // PAN coordinator
        bool assoPmt;           // association permit
};

// extended DSME GTS allocation field (Figure 7-111 - IEEE 802.15.4-2015)
struct ExtDSMEAllocation
{
    	bool direction;					// direction
    	unsigned char allocOrder;		// allocation order
}

// --------------------------------------------------------------------------------------
// packet definitions 
// --------------------------------------------------------------------------------------

//
// The common part of the general MAC frame format (MHR, MFR)
//
// general MAC frame format (Figure 41 - IEEE 802.15.4-2006, Figure 7-1 - IEEE 802.15.4-2015)
packet Ieee802154Frame {
    unsigned short fcs;         // 16-Bit Frame Check Sequence
    //unsigned int fcs;			// TODO: 32-Bit Frame Check Sequence (possible in IEEE 802.15.4-2015)
    // ... MAC frame payload is encapsulated ...
    //IEHeader ie;				// TODO: integration of the information elements and its headers (Figure 7-3 - IEEE 802.15.4-2015)
    Ash ash;                    // Auxiliary Security Header
    MACAddress src;          	// 0, 16 or (TODO:) 64-Bit Source Address
    unsigned short srcPANid;    // 0 or 16-Bits for Source PAN Identifier
    MACAddress dest;         	// 0, 16 or (TODO:) 64-Bit Destination Address
    unsigned short destPANid;   // 0 or 16-Bits for Destination PAN Identifier
    unsigned char sqnr=0;       // 8-Bit Sequence number
    unsigned short fcf=0;       // 16-Bit Frame Control Field
    bool isGTS = false;		    // Added extra for GTS logic
    bool isIndirect=false;      // Added extra for indirect transmissions
}

// beacon frame format (Figure 44 - IEEE 802.15.4-2006, Figure 7-5/7-6 - IEEE 802.15.4-2015)
packet Ieee802154BeaconFrame extends Ieee802154Frame
{
    SuperframeSpec sfSpec;                  // Superframe specifications
    GTSFields gtsFields;					// GTS Fields
    //GTSDescriptor gtsList[7];				// TODO: remove!
    PendingAddrFields paFields;             // includes numLong numShort and List
}

// data frame format (Figure 52 - IEEE 802.15.4-2006, Figure 7-14 - IEEE 802.15.4-2015)
packet Ieee802154DataFrame extends Ieee802154Frame
{
}

// ack frame format (Figure 52 - IEEE 802.15.4-2006, Figure 7-15 - IEEE 802.15.4-2015)
packet Ieee802154AckFrame
{
    unsigned short fcs;     // 16-Bit Frame Check Sequence
    //unsigned int fcs;		// TODO: 32-Bit Frame Check Sequence (possible in IEEE 802.15.4-2015)
    unsigned char sqnr;     // 8-Bit Sequence Number
    unsigned short fcf;     // 16-Bit Framce Control Field
}

// command frame format (Figure 52 - IEEE 802.15.4-2006, Figure 7-17 - IEEE 802.15.4-2015)
packet Ieee802154CmdFrame extends Ieee802154Frame
{
    unsigned char cmdType @enum(Ieee802154MacCmdType);
}

// multipurpose frame format (Figure 7-18 - IEEE 802.15.4-2015)
packet Ieee802154MultiFrame extends Ieee802154Frame
{
    // TODO: definition of an other FCF - overload genFCF()?
}

// extended frame format (Figure 7-20 - IEEE 802.15.4-2015)
packet Ieee802154ExtendedFrame extends Ieee802154Frame
{
    unsigned char frameType;
    unsigned char extFrameType @enum(Ieee802154ExtFrameType);
}

// association command request frame format (Figure 55 - IEEE 802.15.4-2006, Figure 7-102 - IEEE 802.15.4-2015)
packet Ieee802154AssoCmdReq extends Ieee802154CmdFrame
{
    DevCapability CapabilityInformation;	// TODO: genCIF instead of struct?
}

// association command response frame format (Figure 57 - IEEE 802.15.4-2006, Figure 7-104 - IEEE 802.15.4-2015)
packet Ieee802154AssoCmdResp extends Ieee802154CmdFrame
{
    unsigned short shortAddress;
    unsigned short status @enum(Ieee802154AssociationStatus);
}

// disassociation notification command frame format (Figure 58 - IEEE 802.15.4-2006, Figure 7-105 - IEEE 802.15.4-2015)
packet Ieee802154DisassoCmd extends Ieee802154CmdFrame
{
    unsigned char DisassociateReason @enum(Ieee802154DisassociateReason);
}

// coordinator realignment command frame format (Figure 63 - IEEE 802.15.4-2006, Figure 7-106 - IEEE 802.15.4-2015)
packet Ieee802154RealignCmd extends Ieee802154CmdFrame 
{
    unsigned short PANId;				// PAN ID
    unsigned short CoordShortAddr;		// coordinator short address
    unsigned int LogicalChannel;		// channel number / logical channel on which to start using new superframe configuration
    unsigned short ShortAddr;			// short address
    unsigned char ChannelPage;			// 0 - 31, channel page (IEEE 802.15.4-2006)
    
    // 2015 rearranged TODO: channel page / channel number (bits 0-6), page / number (bit 7) (IEEE 802.15.4-2015)
    bool Page;
}

// disassociation notification command frame format (Figure 64 - IEEE 802.15.4-2006, Figure 7-107 - IEEE 802.15.4-2015)
packet Ieee802154GTSCmd extends Ieee802154CmdFrame
{
    GTSCharacteristics gtsCharacteristics;
}

// DSME association request command frame format (Figure 7-109 - IEEE 802.15.4-2015)
packet Ieee802154DSMECmdAssoReq extends Ieee802154CmdFrame
{
    DevCapability CapabilityInformation;	// TODO: genCIF instead of struct?
    unsigned char HoppingSequID;			// Hopping Sequence ID
    unsigned short ChannelOffset;			// Channel Offset
    ExtDSMEAllocation ExtAllocation;		// Extended DSME GTS Allocation
}

// DSME association response command frame format (Figure 7-112 - IEEE 802.15.4-2015)
packet Ieee802154DSMECmdAssoRes extends Ieee802154CmdFrame
{
    // TODO: fields
}

// DSME GTS request command frame format (Figure 7-113 - IEEE 802.15.4-2015)
packet Ieee802154DSMECmdGTSReq extends Ieee802154CmdFrame
{
    // TODO: fields
}

// DSME GTS response command frame format (Figure 7-116 - IEEE 802.15.4-2015)
packet Ieee802154DSMECmdGTSRes extends Ieee802154CmdFrame
{
    // TODO: fields
}

// DSME GTS notify command frame format (Figure 7-118 - IEEE 802.15.4-2015)
packet Ieee802154DSMECmdGTSNotify extends Ieee802154CmdFrame
{
    // TODO: fields
}

// DSME information request command frame format (Figure 7-119 - IEEE 802.15.4-2015)
packet Ieee802154DSMECmdInfoReq extends Ieee802154CmdFrame
{
    unsigned char type @enum(Ieee802154DSMEInfoType);	// Info type
    unsigned char length;								// DSME SAB sub-block length
    unsigned short index;								// DSME SAB sub-block index
}

// DSME information response command frame format (Figure 7-120 - IEEE 802.15.4-2015)
packet Ieee802154DSMECmdInfoRes extends Ieee802154CmdFrame
{
    // TODO: fields
}

// DSME beacon allocation notification command frame format (Figure 7-121 - IEEE 802.15.4-2015)
packet Ieee802154DSMECmdBeaconAlloc extends Ieee802154CmdFrame
{
    unsigned short index;	// Allocation Beacon SD Index
}

// DSME beacon collision notification command frame format (Figure 7-122 - IEEE 802.15.4-2015)
packet Ieee802154DSMECmdBeaconCollision extends Ieee802154CmdFrame
{
    unsigned short index;	// Collision SD Index
}

// DSME link report command frame format (Figure 7-123 - IEEE 802.15.4-2015)
packet Ieee802154DSMECmdLinkReport extends Ieee802154CmdFrame
{
    // TODO: fields
}

// RIT data request command frame format (Figure 7-126 - IEEE 802.15.4-2015)
packet Ieee802154RITCmdDataReq extends Ieee802154CmdFrame
{
    // TODO: fields
}

// DBS request command frame format (Figure 7-129 - IEEE 802.15.4-2015)
packet Ieee802154DBSCmdReq extends Ieee802154CmdFrame
{
    // TODO: fields
}

// DBS response command frame format (Figure 7-131 - IEEE 802.15.4-2015)
packet Ieee802154DBSCmdRes extends Ieee802154CmdFrame
{
    // TODO: fields
}

// RIT data response command frame format (Figure 7-133 - IEEE 802.15.4-2015)
packet Ieee802154RITCmdDataRes extends Ieee802154CmdFrame
{
}

// vendor specific command frame format (Figure 7-134 - IEEE 802.15.4-2015)
packet Ieee802154VendorCmd extends Ieee802154CmdFrame
{
    unsigned long oui;		// Vendor OUI
}