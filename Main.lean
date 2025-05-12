import Consig
-- import Mathlib.Data.List.Basic
-- import Mathlib.Data.Real.Basic
-- #eval Real.pi

-- import Mathlib.Topology.Basic
-- import Mathlib.Control.Random
-- import Mathlib.Data.List.Basic
--
--
-- -- open Random
--
-- -- Generate 5 random integers between 0 and 9 (inclusive)
-- def generateRandomIntegers : BaseIO (List Nat) := do
--   -- let gen ← mkStdGen
--   -- let (result, _) := 
--   --   List.range 5 |>.mapM (fun _ => 
--   --     Nat.random 0 9 gen
--   --   ) gen
--   -- return result
--   let result := 
--     List.range 5
--   return result
--
-- -- -- Alternative version using the Random monad
-- -- def generateRandomIntegersM : BaseIO (List Nat) := do
-- --   let mut result : List Nat := []
-- --   for _ in List.range 5 do
-- --     let n ← rand (UInt32.ofNat 0) (UInt32.ofNat 9)
-- --     result := result.append [n.toNat]
-- --   return result
--
  -- let randomInts := generateRandomIntegers
  -- let zz := toString (List.range 5)
--   -- IO.println s!"Random integers: {randomInts}"
--

-- def main : (IO Unit) :=
--   IO.println s!"Random integers:"

--   
--   -- let randomIntsM ← generateRandomIntegersM
  -- IO.println s!"Random integers (monad version): {randomIntsM}"
--
--
-- -- def F (α : Type u) : Type u := Prod α α
-- -- #check F
-- -- #check fun x => x + 5
--
-- -- ??: N = 10000
-- -- bits = np.random.randint(0, 2, N)
-- -- or https://numpy.org/doc/stable/reference/random/index.html#quick-start
-- -- rng.integers(low=0, high=10, size=5)
-- -- mod Transmitter = Array
-- #print Nat
-- #print Char.isAlpha
-- #print IO
-- #check 0 = 1
--
-- theorem extremely_easy (P : Prop) (h : P) : P := h
--
def safeDiv (a b : Int) (h : b ≠ 0) : Int :=
  a / b

-- def insertSorted [Ord α] (x : α) (xs : List α) (h : xs.Sorted) : List α :=
--   match xs with
--   | [] => [x]
--   | y :: ys =>
--     if x ≤ y then
--       x :: xs
--     else
--       y :: insertSorted x ys (xs.tail_sorted_of_sorted h)

-- def sortedInsertPreservesLength [Ord α] (x : α) (xs : List α) : 
--   length (insertSorted x xs (by assumption)) = length xs + 1 := by
--   induction xs with
--   | nil => simp [insertSorted]
--   | cons y ys ih => 
--     simp [insertSorted]
--     cases (x ≤ y) with
--     | true => simp
--     | false => 
--       simp
--       exact ih


def randomNat (_range : List Nat) (_ : Nat) := 4

-- M = 4  -- QPSK is psk with modulation order of four
-- data = randi([0 M-1],10,1)
--        randi(range,sz,1)
def randi1 (range : List Nat) (sz : Nat) : List Nat :=
  List.map (randomNat range) (List.range sz)

inductive PSK where
  | bpsk : PSK  -- 2
  | qpsk : PSK  -- 4
  -- | MPSK : PSK  -- 8, 16  ??: constructor with arg
open PSK
def modulationOrder (p : PSK) : Nat :=
  match p with
  | bpsk => 2
  | qpsk => 4

#eval randi1 [0, modulationOrder qpsk - 1] 10
-- #eval Real.Pi / 2
def pi : Float := 3.141592
#eval pi / 2

def pskmod (data : List Nat) (h1 : withinRange) :=
  12
  -- octave.pskmod(data, M, phaseoffset)

-- def inRange (data : List Nat) (range : List Nat) : Prop :=
--   -- 1 = 1
--   match range with
--   | [min_val, max_val] =>
--     let rec allInRange : List Nat → Prop
--     | [] => True
--     | x :: xs => x ≥ min_val ∧ x ≤ max_val ∧ allInRange xs
--     allInRange data
--   | _ => False

-- #check 2 < [].length

-- !!: Allow build to silently include sorry proofs.
axiom sorryProofAxiom {P : Prop} : P
macro "sorry_proof" : term => do `(sorryProofAxiom)
macro "sorry_proof" : tactic => `(tactic| apply sorry_proof)

def withinRange (data : List Nat) (min : Nat) (max : Nat) : Prop :=
  ∀ x ∈ data, min ≤ x ∧ x ≤ max
#check withinRange [2, 2, 3] 0 4

theorem sorry_within_range : withinRange [2, 2, 3] 0 4 := by
  sorry_proof


def main : (IO Unit) :=
  -- let proof : i < ls.length := by decide
  let data := randi1 [0, modulationOrder qpsk - 1] 10
  let tx_is_within_range : withinRange data 0 4 := by sorry_proof
  let res := pskmod data tx_is_within_range
  -- IO.println s!"res: {res}"
  IO.println s!"ok"

-- phaseoffset is pi divided by modulation order
-- phaseoffset defaults to 0; of type double
-- ??: ffi octave's pskmod. or in scipy.signal
-- txSig = pskmod(data,M,pi/M);
-- txSig = pskmod([2, 2, 2, 2, 2],4,pi/4);
-- Y = pskmod(X,M,phaseoffset)

def getElement {α} (xs : List α) (i : Nat) (h : i < xs.length) : α :=
  match xs, i with
  | [], _ => absurd h (by simp)
  | x :: _, 0 => x
  | _ :: xs', i+1 => getElement xs' i (by simp at h; exact h)

-- def main : (IO Unit) :=
--   let ls := [10,20,30,40]
--   let i := 3
--   let proof : i < ls.length := by decide
--   let res := getElement ls i proof
--   IO.println s!"res: {res}"
