// SPDX-License-Identifier : Unlicense 
pragma solidity >=0.5.0<0.9.0;

contract EventContract {

     struct Event{
         address organiser;
         string name;
         uint date;
         uint price;
         uint ticketcount;
         uint ticketremains;
     }

   mapping(uint=> Event) public events;
   mapping(address=>mapping(uint=>uint)) public tickets;
   uint public nextId;

   function createEvent( string memory name, uint date, uint price, uint ticketCount) external{
       require(date>block.timestamp," You can organise event for future");
       require(ticketCount>0," Your ticket is not enough");

     events[nextId]=Event(msg.sender,name,date,price,ticketCount,ticketCount);
     nextId++;

   } 

   function Buyticket(uint id, uint quantity) external payable {
       require(events[id].date!=0,"Event not available");
       require(block.timestamp<events[id].date,"Event is finished");
       Event storage _event= events[id];
       require(msg.value==(_event.price*quantity),"Ether is not enough");
       require(_event.ticketremains>=quantity,"Not Enough Tickets");
       _event.ticketremains-=quantity;
       
       tickets[msg.sender][id]+=quantity;  // initially there was 0
   }

   function transferTicket(uint eventId, uint quantity, address to) external {
    require(events[eventId].date!=0,"Event not available");
       require(block.timestamp<events[eventId].date,"Event is finished");
       require(tickets[msg.sender][eventId]>=quantity," You do not have enough tickets");
       tickets[msg.sender][eventId]-= quantity;
       tickets[to][eventId]+=quantity;


   }


}