`include "./Cache_Components/Cache_define_macro.v"
module Comparator(Tag1, Tag2, Match);
input [`TAG_LENGTH-1:0] Tag1;
input [`TAG_LENGTH-1:0] Tag2;
output Match;
assign Match = (Tag1 == Tag2);
endmodule