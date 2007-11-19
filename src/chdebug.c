/*
    ChibiOS/RT - Copyright (C) 2006-2007 Giovanni Di Sirio.

    This file is part of ChibiOS/RT.

    ChibiOS/RT is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 3 of the License, or
    (at your option) any later version.

    ChibiOS/RT is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include <ch.h>

#ifdef CH_USE_DEBUG

TraceBuffer dbgtb;
char *dbglastmsg;

/**
 * Debug subsystem initialization.
 */
void chDbgInit(void) {

  dbgtb.tb_size = TRACE_BUFFER_SIZE;
  dbgtb.tb_ptr = &dbgtb.tb_buffer[0];
}

/**
 * Inserts in the circular debug trace buffer a context switch record.
 * @param otp the thread being switched out
 * @param ntp the thread to be resumed
 */
void chDbgTrace(Thread *otp, Thread *ntp) {

  dbgtb.tb_ptr->cse_slpdata = otp->p_common;
#ifdef CH_USE_SYSTEMTIME
  dbgtb.tb_ptr->cse_time = chSysGetTime();
#else
  dbgtb.tb_ptr->cse_time = 0;
#endif
  dbgtb.tb_ptr->cse_state = otp->p_state;
  dbgtb.tb_ptr->cse_tid = ntp->p_tid;
  if (++dbgtb.tb_ptr >= &dbgtb.tb_buffer[TRACE_BUFFER_SIZE])
    dbgtb.tb_ptr = &dbgtb.tb_buffer[0];
}

/**
 * Prints a message on the console/debugger. The latest message pointer
 * is retained.
 */
void chDbgPuts(char *msg) {

  dbglastmsg = msg;
  chSysPuts(msg);
}

/**
 * Prints a panic message on the console/debugger and then halts the system.
 */
void chDbgPanic(char *msg) {

  chSysPuts("PANIC: ");
  chDbgPuts(msg);
  chSysHalt();
}

#endif /* CH_USE_DEBUG */
