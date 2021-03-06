/* -*- Mode: C++; c-basic-offset: 2; tab-width: 2; indent-tabs-mode: nil -*-
 * 
 * Quadra, an action puzzle game
 * Copyright (C) 1998-2000  Ludus Design
 * 
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

#ifndef _HEADER_QSERV
#define _HEADER_QSERV

#include <stdint.h>

#include "types.h"

class Http_post;
class Dict;
class Textbuf;

class Qserv {
	Http_post *req;
	char status[256];
	Dict *reply;
	void create_req();
public:
	static uint32_t http_addr;
	static int http_port;
	Qserv();
	virtual ~Qserv();
	bool done();
	void add_data(const char *s, ...);
	void add_data_large(const Textbuf &buf); // 'buf' must be url-encoded already
	void send();
	bool bad_reply();
	const char *get_status();
	Dict *get_reply();
	bool isconnected() const;
	uint32_t getnbrecv() const;
};

#endif
