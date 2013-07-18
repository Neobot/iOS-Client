//
//  PXGInstructions.h
//  Neobot Client
//
//  Created by Thibaud Rabillard on 18/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//

#ifndef Neobot_Client_PXGInstructions_h
#define Neobot_Client_PXGInstructions_h

/**
 * \brief Maximum lentgh of the data.
 */
const int MAX_LENGTH = 20;

/**
 * \brief Factor to send an angle in radian through the comm
 */
const double ANGLE_FACTOR = 1000.0;

//PC -> microC
const uint8_t DEST_ADD = 1;
const uint8_t DEST_REPLACE = 2;
const uint8_t FLUSH = 3;
const uint8_t SET_POS = 10;
const uint8_t SERVO_ANGLE = 20;
const uint8_t SERVO_POS = 21;
const uint8_t GET_SENSOR = 30;
const uint8_t SET_PARAMETERS = 50;
const uint8_t ASK_PARAMETERS = 51;
const uint8_t ACTIONS = 60;

//microC -> PC
const uint8_t COORD = 100;
const uint8_t OPPONENT = 101;
const uint8_t IS_ARRIVED = 102;
const uint8_t IS_BLOCKED = 103;
const uint8_t OBJECTIVE = 104;
const uint8_t AVOIDING_SENSORS = 110;
const uint8_t MICROSWITCHS = 111;
const uint8_t OTHER_SENSORS = 112;

const uint8_t INIT_DONE = 120;
const uint8_t GO = 121;
const uint8_t RESTART = 122;
const uint8_t QUIT = 123;
const uint8_t LOG = 124;
const uint8_t PARAMETERS = 125;
const uint8_t PARAMETER_NAMES = 126;

//global
const uint8_t PING = 254;
const uint8_t AR = 255;


//Network commands
//Server -> Client
const uint8_t ANNOUNCEMENT = 180;
const uint8_t SEND_STRATEGIES = 181;
const uint8_t SEND_STRATEGY_FILES = 182;
const uint8_t SEND_STRATEGY_FILE_DATA = 183;
const uint8_t SERIAL_PORTS = 184;
const uint8_t AX12_POSITIONS = 185;
const uint8_t STRATEGY_STATUS = 186;
const uint8_t AUTO_STRATEGY_INFO = 187;
const uint8_t AX12_MVT_FILE = 188;

//Client -> Server
const uint8_t CONNECT = 200;
const uint8_t DISCONNECT = 201;
const uint8_t UPDATE_SERVER = 202;
const uint8_t PING_SERVER = 203;
const uint8_t ASK_STRATEGIES = 204;
const uint8_t ASK_STRATEGY_FILES = 205;
const uint8_t ASK_STRATEGY_FILE_DATA = 206;
const uint8_t SET_STRATEGY_FILE_DATA = 207;
const uint8_t RESET_STRATEGY_FILE = 208;
const uint8_t ASK_SERIAL_PORTS = 209;
const uint8_t MOVE_AX12 = 210;
const uint8_t ASK_AX12_POSITIONS = 211;
const uint8_t START_STRATEGY = 212;
const uint8_t STOP_STRATEGY = 213;
const uint8_t ASK_STRATEGY_STATUS = 214;
const uint8_t SET_AUTO_STRATEGY = 215;
const uint8_t ASK_AUTO_STRATEGY_INFO = 216;
const uint8_t ASK_AX12_MVT_FILE = 217;
const uint8_t SET_AX12_MVT_FILE = 218;
const uint8_t RUN_AX12_MVT = 219;
const uint8_t LOCK_AX12 = 220;

#endif
