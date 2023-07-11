Martin Escardo & Tom de Jong, June 2023.

Iterative multisets.

\begin{code}

{-# OPTIONS --safe --without-K --exact-split #-}

open import MLTT.Spartan

module Iterative.Multisets
        (𝓤 : Universe)
       where

open import Iterative.W-Properties (𝓤 ̇) id
open import MLTT.W
open import UF.Base
open import UF.Equiv
open import UF.EquivalenceExamples
open import UF.FunExt
open import UF.Size
open import UF.Subsingletons
open import UF.UA-FunExt
open import UF.Univalence

\end{code}

The type of iterative multisets:

\begin{code}

𝕄 : 𝓤 ⁺ ̇
𝕄 = W (𝓤 ̇ ) id

\end{code}

This is equivalent to the following alternative definition.

\begin{code}

private

 data 𝕄' : 𝓤 ⁺ ̇ where
  ssup : (X : 𝓤 ̇ ) (φ : X → 𝕄') → 𝕄'

 𝕄-to-𝕄' : 𝕄 → 𝕄'
 𝕄-to-𝕄' (ssup X φ) = ssup X (λ x → 𝕄-to-𝕄' (φ x))

 𝕄'-to-𝕄 : 𝕄' → 𝕄
 𝕄'-to-𝕄 (ssup X φ) = ssup X (λ x → 𝕄'-to-𝕄 (φ x))

\end{code}

Maybe add the proof that the above two functions are mutually
inverse. But the only point of adding them is to make sure that the
above comment remains valid if any change is made, and the above two
definitions seems to be enough for that purpose.


Every W-type can be mapped to 𝕄 as follows:

\begin{code}

W-to-𝕄 : {X : 𝓤 ̇ } {A : X → 𝓤 ̇ }
       → W X A → 𝕄
W-to-𝕄 {X} {A} (ssup x f) = ssup (A x) (λ a → W-to-𝕄 (f a))

\end{code}

In the case of ordinals, ssup stands for "strong supremum", "strict
supremum" or "supremum of successors.

\begin{code}

𝕄-root : 𝕄 → 𝓤 ̇
𝕄-root = W-root

𝕄-forest : (M : 𝕄) → 𝕄-root M → 𝕄
𝕄-forest = W-forest

\end{code}

The induction principle for 𝕄:

\begin{code}

𝕄-induction : (P : 𝕄 → 𝓥 ̇ )
            → ((X : 𝓤 ̇ ) (ϕ : X → 𝕄)
                  → ((x : X) → P (ϕ x))
                  → P (ssup X ϕ))
            → (M : 𝕄) → P M
𝕄-induction = W-induction

𝕄-recursion : (P : 𝓥 ̇ )
            → ((X : 𝓤 ̇ ) → (X → 𝕄) → (X → P) → P)
            → 𝕄 → P
𝕄-recursion = W-recursion

𝕄-iteration : (P : 𝓥 ̇ )
            → ((X : 𝓤 ̇ ) → (X → P) → P)
            → 𝕄 → P
𝕄-iteration = W-iteration

\end{code}

A criterion for equality in 𝕄:

\begin{code}

to-𝕄-＝ : {X Y : 𝓤 ̇ }
          {φ : X → 𝕄}
          {γ : Y → 𝕄}
        → (Σ p ꞉ X ＝ Y , φ ＝ γ ∘ Idtofun p)
        → ssup X φ ＝[ 𝕄 ] ssup Y γ
to-𝕄-＝ = to-W-＝

from-𝕄-＝ : {X Y : 𝓤 ̇ }
            {φ : X → 𝕄}
            {γ : Y → 𝕄}
          → ssup X φ ＝[ 𝕄 ] ssup Y γ
          → Σ p ꞉ X ＝ Y , φ ＝ γ ∘ Idtofun p
from-𝕄-＝ = from-W-＝

from-to-𝕄-＝ : {X Y : 𝓤 ̇ }
            {φ : X → 𝕄}
            {γ : Y → 𝕄}
            (σ : Σ p ꞉ X ＝ Y , φ ＝ γ ∘ Idtofun p)
          → from-𝕄-＝ {X} {Y} {φ} {γ} (to-𝕄-＝ σ) ＝[ type-of σ ] σ
from-to-𝕄-＝ = from-to-W-＝

to-from-𝕄-＝ : {X Y : 𝓤 ̇ }
            {φ : X → 𝕄}
            {γ : Y → 𝕄}
            (p : ssup X φ ＝ ssup Y γ)
          → to-𝕄-＝ (from-𝕄-＝ p) ＝ p
to-from-𝕄-＝ = to-from-W-＝

𝕄-＝ : {X Y : 𝓤 ̇ }
       {φ : X → 𝕄}
       {γ : Y → 𝕄}
     → ((ssup X φ) ＝[ 𝕄 ] (ssup Y γ))
     ≃ (Σ p ꞉ X ＝ Y , φ ＝ γ ∘ Idtofun p)
𝕄-＝ = W-＝

\end{code}

We now show that 𝕄 is locally small assuming univalence.

\begin{code}

_≃ᴹ_ : 𝕄 → 𝕄 → 𝓤 ̇
ssup X f ≃ᴹ ssup X' f' = Σ 𝕗 ꞉ X ≃ X' , ((x : X) → f x ≃ᴹ f' (⌜ 𝕗 ⌝ x))

≃ᴹ-refl : (M : 𝕄) → M ≃ᴹ M
≃ᴹ-refl (ssup X f) = ≃-refl X , (λ x → ≃ᴹ-refl (f x))

singleton-typeᴹ : 𝕄 → 𝓤 ⁺ ̇
singleton-typeᴹ M = Σ t ꞉ 𝕄 , M ≃ᴹ t

M-center : (M : 𝕄) → singleton-typeᴹ M
M-center M = M , ≃ᴹ-refl M

M-centrality : Univalence
             → (M : 𝕄) (σ : singleton-typeᴹ M) → M-center M ＝ σ
M-centrality ua (ssup X φ) (ssup Y γ , 𝕗 , u) =
 V (eqtoid (ua 𝓤) X Y 𝕗) (idtoeq-eqtoid (ua 𝓤) X Y 𝕗 ⁻¹)
 where
  V : (p : X ＝ Y) → 𝕗 ＝ idtoeq X Y p → M-center (ssup X φ) ＝ ssup Y γ , 𝕗 , u
  V refl refl = IV
   where
    IH : (x : X) → M-center (φ x) ＝ γ (⌜ 𝕗 ⌝ x) , u x
    IH x = M-centrality ua (φ x) (γ (⌜ 𝕗 ⌝ x) , u x)

    I : (λ x → M-center (φ x)) ＝ (λ x → γ (⌜ 𝕗 ⌝ x) , u x)
    I = dfunext (Univalence-gives-Fun-Ext ua) IH

    π : (Σ δ ꞉ (X → 𝕄) , ((x : X) → φ x ≃ᴹ δ x))
      → singleton-typeᴹ (ssup X φ)
    π (δ , v) = ssup X δ , ≃-refl X , v

    II : (φ , λ x → ≃ᴹ-refl (φ x)) ＝ (γ ∘ ⌜ 𝕗 ⌝ , u)
    II = ap ΠΣ-distr I

    III : (ssup X φ , ≃-refl X , λ x → ≃ᴹ-refl (φ x)) ＝ (ssup X (γ ∘ ⌜ 𝕗 ⌝) , ≃-refl X , u)
    III = ap π II

    IV =
     M-center (ssup X φ)                         ＝⟨ refl ⟩
     ssup X φ , ≃-refl X , (λ x → ≃ᴹ-refl (φ x)) ＝⟨ III ⟩
     ssup X (γ ∘ ⌜ 𝕗 ⌝) , ≃-refl X , u           ＝⟨ refl ⟩
     ssup Y γ , 𝕗 , u                            ∎

singleton-typesᴹ-are-singletons : Univalence
                                → (M : 𝕄) → is-singleton (singleton-typeᴹ M)
singleton-typesᴹ-are-singletons ua M = M-center M , M-centrality ua M

idtoeqᴹ : (M t : 𝕄) → M ＝ t → M ≃ᴹ t
idtoeqᴹ M M refl = ≃ᴹ-refl M

idtoeqᴹ-is-equiv : Univalence
                 → (M t : 𝕄) → is-equiv (idtoeqᴹ M t)
idtoeqᴹ-is-equiv ua M = I
 where
  f : singleton-type M → singleton-typeᴹ M
  f = NatΣ (idtoeqᴹ M)

  f-is-equiv : is-equiv f
  f-is-equiv = maps-of-singletons-are-equivs f
                (singleton-types-are-singletons M)
                (singleton-typesᴹ-are-singletons ua M)

  I : (t : 𝕄) → is-equiv (idtoeqᴹ M t)
  I = NatΣ-equiv-gives-fiberwise-equiv (idtoeqᴹ M) f-is-equiv

𝕄-is-locally-small : Univalence → is-locally-small 𝕄
𝕄-is-locally-small ua M N = M ≃ᴹ N ,
                          ≃-sym (idtoeqᴹ M N , idtoeqᴹ-is-equiv ua M N)
