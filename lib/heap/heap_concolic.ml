open Smtml

module M = struct
  type value =
    Value.t * Expr.t (* indexes and sizes are always values *)

  type block = value array
  type t = (int, block) Hashtbl.t

  let init ?(next = 0) () : t =
    ignore next;
    Hashtbl.create Parameters.size

  let pp (_fmt : Fmt.t) (_heap : t) : unit = failwith "Not Implemented"
  let to_string (_h : t) : string = failwith "Not Implemented"

  let malloc _h (_sz : value) (_pc : value Pc.t) : (t * value * value Pc.t) list
      =
    []

  let update _h (_arr : value) (_index : value) (_v : value) (_pc : value Pc.t)
    : (t * value Pc.t) list =
    []

  let lookup _h (_arr : value) (_index : value) (_pc : value Pc.t) :
    (t * value * value Pc.t) list =
    []

  let free _h (_arr : value) (_pc : value Pc.t) : (t * value Pc.t) list = []

  let in_bounds (_heap : t) (_v : value) (_i : value) (_pc : value Pc.t) : bool
      =
    failwith "not implemented"

  let get_block (_h : t) (_addr : value) : block option = assert false
  let set_block (_h : t) (_addr : value) (_block : block) : t = assert false
  let clone _ = assert false
end

module M' : Heap_intf.M with type value = Value.t * Expr.t = M
include M
(*
type t = (int, int arry) Hashtbl.t

x := new (5);
----
heap = { 1 -> { 0 -> 0, 1 -> 0, 2 -> 0, 3 -> 0, 4 -> 0} }
store = { x -> Loc 1 }
x[1] := 3;
----
heap = { 1 -> { 0 -> 0, 1 -> 3, 2 -> 0, 3 -> 0, 4 -> 0} }
store = { x -> Loc 1 }
---
y := x[0]
---
heap = { 1 -> { 0 -> 0, 1 -> 3, 2 -> 0, 3 -> 0, 4 -> 0} }
store = { x -> Loc 1, y -> Int 0 }
*)
