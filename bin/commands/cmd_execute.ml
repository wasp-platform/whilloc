open Whilloc
open Utils

(* Heap *)

module HeapHierarchy = Heap_hierarchy.M (Heap_oplist)

(* Choice *)
module C_Choice = List_choice.Make (Eval_concrete) (Heap_concrete)
module SAF_Choice = List_choice.Make (Eval_symbolic) (Heap_array_fork)
module SAITE_Choice = List_choice.Make (Eval_symbolic) (Heap_arrayite)
module ST_Choice = List_choice.Make (Eval_symbolic) (Heap_tree)
module SOPL_Choice = List_choice.Make (Eval_symbolic) (Heap_oplist)
module SH_Choice = List_choice.Make (Eval_symbolic.M) (HeapHierarchy)

(* Interpreter *)
module C = Interpreter.Make (Eval_concrete) (Dfs) (Heap_concrete) (C_Choice)

module SAF =
  Interpreter.Make (Eval_symbolic) (Dfs) (Heap_array_fork) (SAF_Choice)

module SAITE =
  Interpreter.Make (Eval_symbolic) (Dfs) (Heap_arrayite) (SAITE_Choice)

module ST = Interpreter.Make (Eval_symbolic) (Dfs) (Heap_tree) (ST_Choice)
module SOPL = Interpreter.Make (Eval_symbolic) (Dfs) (Heap_oplist) (SOPL_Choice)

module SH =
  Interpreter.Make (Eval_symbolic.M) (Dfs.M) (HeapHierarchy) (SH_Choice)

type mode =
  | Concrete
  | Saf
  | Saite
  | St
  | Sopl
  | Sh
[@@deriving yojson]

type report =
  { filename : string
  ; mode : mode
  ; execution_time : float
  ; solver_time : float
  ; num_paths : int
  ; num_problems : int
  ; problems : Outcome.t list
  }
[@@deriving yojson]

type options =
  { input : Fpath.t
  ; mode : mode
  ; output : Fpath.t option
  ; verbose : bool
  }

let mode_to_string = function
  | Concrete -> "c"
  | Saf -> "saf"
  | Saite -> "saite"
  | St -> "st"
  | Sopl -> "sopl"
  | Sh -> "sh"

let write_report report =
  let json = report |> report_to_yojson |> Yojson.Safe.to_string in
  let file = Fpath.v "report.json" in
  match Bos.OS.File.write file json with
  | Ok v -> v
  | Error (`Msg err) -> failwith err

let run ?(no_values = false) ?(test = false) input mode =
  let start = Sys.time () in
  print_header ();
  let program = input |> read_file |> parse_program |> create_program in
  Printf.printf "Input file: %s\nExecution mode: %s\n\n" input
    (mode_to_string mode);
  let problems, num_paths =
    match mode with
    | Concrete ->
      let rets = C.interpret program in
      ( List.filter_map
          (fun (out, _) ->
            if test then Format.printf "%a@." (Outcome.pp ~no_values) out;
            match out with
            | Outcome.Error _ | Outcome.EndGas -> Some out
            | _ -> None )
          rets
      , List.length rets )
    | Saf ->
      let rets = SAF.interpret program in
      ( List.filter_map
          (fun (out, _) ->
            if test then Format.printf "%a@." (Outcome.pp ~no_values) out;
            match out with
            | Outcome.Error _ | Outcome.EndGas -> Some out
            | _ -> None )
          rets
      , List.length rets )
    | Saite ->
      let rets = SAITE.interpret program in
      ( List.filter_map
          (fun (out, _) ->
            if test then Format.printf "%a@." (Outcome.pp ~no_values) out;
            match out with
            | Outcome.Error _ | Outcome.EndGas -> Some out
            | _ -> None )
          rets
      , List.length rets )
    | St ->
      let rets = ST.interpret program in
      ( List.filter_map
          (fun (out, _) ->
            if test then Format.printf "%a@." (Outcome.pp ~no_values) out;
            match out with
            | Outcome.Error _ | Outcome.EndGas -> Some out
            | _ -> None )
          rets
      , List.length rets )
    | Sopl ->
      let rets = SOPL.interpret program in
      ( List.filter_map
          (fun (out, _) ->
            if test then Format.printf "%a@." (Outcome.pp ~no_values) out;
            match out with
            | Outcome.Error _ | Outcome.EndGas -> Some out
            | _ -> None )
          rets
      , List.length rets )
    | Sh ->
      let rets = SH.interpret program in
      ( List.filter_map
          (fun (out, _) ->
            if test then Format.printf "%a@." (Outcome.pp ~no_values) out;
            match out with
            | Outcome.Error _ | Outcome.EndGas -> Some out
            | _ -> None )
          rets
      , List.length rets )
  in

  let execution_time = Sys.time () -. start in
  let num_problems = List.length problems in
  if num_problems = 0 then Printf.printf "Everything Ok!\n"
  else Printf.printf "Found %d problems!\n" num_problems;
  if !Utils.verbose then
    Printf.printf
      "\n\
       =====================\n\
       Total Execution time: %f\n\
       Total Solver time: %f\n"
      execution_time
      !Smtml.Solver.Z3_batch.solver_time;
  write_report
    { execution_time
    ; mode
    ; num_paths
    ; num_problems
    ; problems
    ; filename = input
    ; solver_time = !Smtml.Solver.Z3_batch.solver_time
    }

let main (opts : options) =
  Utils.verbose := opts.verbose;
  run (Fpath.to_string opts.input) opts.mode
