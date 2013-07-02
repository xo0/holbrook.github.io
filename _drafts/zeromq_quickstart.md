借用官方的例子：
客户端（发送N个“Hello”消息到服务端，接受回应）：

//
//  Hello World client
//  Connects REQ socket to tcp://localhost:5555
//  Sends "Hello" to server, expects "World" back
//
#include <zmq.h>
#include <string.h>
#include <stdio.h>
#include <unistd.h>
int main () {
void *context = zmq_init (1);
//  Socket to talk to server
printf ("Connecting to hello world server...\n");
void *requester = zmq_socket (context, ZMQ_REQ);
zmq_connect (requester, "tcp://localhost:5555");
int request_nbr;
for (request_nbr = 0; request_nbr != 10; request_nbr++) {
zmq_msg_t request;
zmq_msg_init_data (&request, "Hello", 6, NULL, NULL);
printf ("Sending request %d...\n", request_nbr);
zmq_send (requester, &request, 0);
zmq_msg_close (&request);
zmq_msg_t reply;
zmq_msg_init (&reply);
zmq_recv (requester, &reply, 0);
printf ("Received reply %d: [%s]\n", request_nbr,
(char *) zmq_msg_data (&reply));
zmq_msg_close (&reply);
}
zmq_close (requester);
zmq_term (context);
return 0;
}
服务端（接收客户端的消息，返回“World”给客户端）：

//
//  Hello World server in C++
//  Binds REP socket to tcp://*:5555
//  Expects "Hello" from client, replies with "World"
//
#include <zmq.hpp>
#include <unistd.h>
#include <stdio.h>
#include <string.h>
int main () {
//  Prepare our context and socket
zmq::context_t context (1);
zmq::socket_t socket (context, ZMQ_REP);
socket.bind ("tcp://*:5555");
while (true) {
zmq::message_t request;
//  Wait for next request from client
socket.recv (&request);
printf ("Received request: [%s]\n",
(char *) request.data ());
//  Do some 'work'
sleep (1);
//  Send reply back to client
zmq::message_t reply (6);
memcpy ((void *) reply.data (), "World", 6);
socket.send (reply);
}
return 0;
}
一个套接字相关的调用都没有，一个网络程序就写好了，生活真美好啊。