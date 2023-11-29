open Whilloc
open Utils
module Choice = ListChoice.Make (EvalSymbolic.M) (HeapArrayFork.M)

module SAF =
  Interpreter.Make (EvalSymbolic.M) (DFS.M) (HeapArrayFork.M) (Choice)

(* module C  = MakeInterpreter.M (EvalConcrete.M) (DFS.M) (HeapConcrete.M) *)
(* module SAITE  = MakeInterpreter.M (EvalSymbolic.M) (DFS.M) (HeapArrayITE.M) *)
(* module ST  = MakeInterpreter.M (EvalSymbolic.M) (DFS.M) (HeapTree.M) *)
(* module SOPL  = MakeInterpreter.M (EvalSymbolic.M) (DFS.M) (HeapOpList.M) *)
(* module CC = MakeInterpreter.M (EvalConcolic.M) (DFS.M) (HeapConcolic.M) *)

(* let rec concolic_loop (program : Program.program) (global_pc : Expression.t PathCondition.t) (outs : (CC.t, CC.h) Return.t list) : (CC.t, CC.h) Return.t list = *)
(*   let model = Translator.find_model global_pc () in *)
(*   match model with *)
(*   | true, Some model -> *)
(*       let ()      = SymbMap.update model  in *)
(*       let returns,conts = CC.interpret program !out () in *)
(*       ignore conts; *)
(*       let return  = List.hd returns in *)
(*       let state,_ = return          in *)
(*       let _,pc    = List.split (State.get_pathcondition state) in *)
(*       let neg_pc  = PathCondition.negate pc                    in *)
(*       concolic_loop program (neg_pc::global_pc) (return::outs) *)
(*   | false, _ -> *)
(*       let _ = SymbMap.clear () in *)
(*       outs *)
(*   | _ -> failwith "Unreachable" *)

let main () =
  print_string "\n=====================\n\tÆnima\n=====================\n\n";
  arguments ();
  if !file = "" && !mode = "" then print_string "\nNo option selected. Use -h\n"
  else if !file = "" then
    print_string
      "No input file. Use -i\n\n\
       =====================\n\
       \tFINISHED\n\
       =====================\n"
  else if !mode = "" then
    print_string
      "No mode selected. Use -m\n\n\
       =====================\n\
       \tFINISHED\n\
       =====================\n"
  else
    let program = !file |> read_file |> parse_program |> create_program in
    Printf.printf "Input file: %s\nExecution mode: %s\n\n" !file !mode;
    match !mode with
    | "saf" ->
        let rets = SAF.interpret program in
        List.iter
          (fun (out, _) ->
            Format.printf "Outcome: %s@." (Outcome.to_string out))
          rets
    | _ -> assert false
(* let str_of_returns = *)
(* match !mode with *)
(*   | "c"     -> let returns,_ = C.interpret program !out () in *)
(*              String.concat "\n" (List.map (Return.string_of_return EvalConcrete.M.to_string (fun _ -> "")) returns) *)
(*   | "saf"     -> let returns,_ = SAF.interpret program !out () in *)
(*              String.concat "\n" (List.map (Return.string_of_return EvalSymbolic.M.to_string HeapArrayFork.M.to_string) returns) *)
(*   | "saite" -> let returns,_ = SAITE.interpret program !out () in *)
(*              String.concat "\n" (List.map (Return.string_of_return EvalSymbolic.M.to_string HeapArrayITE.M.to_string) returns) *)
(*   | "sopl"  -> let returns,_ = SOPL.interpret program !out () in *)
(*              String.concat "\n" (List.map (Return.string_of_return EvalSymbolic.M.to_string HeapOpList.M.to_string) returns) *)
(*   | "st"    -> let returns,_ = ST.interpret program !out () in *)
(*              String.concat "\n" (List.map (Return.string_of_return EvalSymbolic.M.to_string (fun _ -> "")) returns) *)
(*   | "cc"    -> let returns   = concolic_loop program [ ] [ ] in *)
(*              String.concat "\n" (List.map (Return.string_of_return EvalConcolic.M.to_string (fun _ -> "")) returns) *)
(* | _   -> invalid_arg "Unknown provided mode. Available modes are:\n  c : for concrete interpretation\n *)
   (*                                                                        saf : for symbolic interpretation with array fork memory\n *)
   (*                                                                        saite : for symbolic interpretation with array ite memory\n *)
   (*                                                                        sopl : for symbolic interpretation with op list memory\n *)
   (*                                                                        st : for symbolic interpretation with tree memory\n *)
   (*                                                                        cc : for concolic interpretation" *)

let () = main ()
