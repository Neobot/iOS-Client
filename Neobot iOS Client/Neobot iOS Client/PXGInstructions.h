//
//  PXGInstructions.m
//  Neobot Client
//
//  Created by Thibaud Rabillard on 20/07/13.
//  Copyright (c) 2013 Pixelgames. All rights reserved.
//


/**
 * \brief Maximum lentgh of the data.
 */
#define MAX_LENGTH  20

/**
 * \brief Factor to send an angle in radian through the comm
 */
#define ANGLE_FACTOR  1000.0

//PC -> microC
#define DEST_ADD  1
#define DEST_REPLACE  2
#define FLUSH  3
#define SET_POS  10
#define ENABLE_SENSOR  20
#define DISABLE_SENSOR  21
#define SET_PARAMETERS  50
#define ASK_PARAMETERS  51
#define ACTIONS  60

//microC -> PC
#define COORD  100
#define OPPONENT  101
#define OBJECTIVE  104
#define AVOIDING_SENSORS  110

#define INIT_DONE  120
#define GO  121
#define RESTART  122
#define QUIT  123
#define LOG  124
#define PARAMETERS  125
#define PARAMETER_NAMES  126
#define EVENT 130
#define SENSOR_EVENT 131

//global
#define PING  254
#define AR  255


//Network commands
//Server -> Client
#define ANNOUNCEMENT  180
#define SEND_STRATEGIES  181
#define SEND_STRATEGY_FILES  182
#define SEND_STRATEGY_FILE_DATA  183
#define SERIAL_PORTS  184
#define AX12_POSITIONS  185
#define STRATEGY_STATUS  186
#define AUTO_STRATEGY_INFO  187
#define AX12_MVT_FILE  188

//Client -> Server
#define CONNECT  200
#define DISCONNECT  201
#define UPDATE_SERVER  202
#define PING_SERVER  203
#define ASK_STRATEGIES  204
#define ASK_STRATEGY_FILES  205
#define ASK_STRATEGY_FILE_DATA  206
#define SET_STRATEGY_FILE_DATA  207
#define RESET_STRATEGY_FILE  208
#define ASK_SERIAL_PORTS  209
#define MOVE_AX12  210
#define ASK_AX12_POSITIONS  211
#define START_STRATEGY  212
#define STOP_STRATEGY  213
#define ASK_STRATEGY_STATUS  214
#define SET_AUTO_STRATEGY  215
#define ASK_AUTO_STRATEGY_INFO  216
#define ASK_AX12_MVT_FILE  217
#define SET_AX12_MVT_FILE  218
#define RUN_AX12_MVT  219
#define LOCK_AX12  220
#define RESET_PARAMETERS  221

