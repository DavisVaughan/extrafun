# is size stable on `x`

    Code
      replace_when(5:10, c(TRUE, FALSE), 2)
    Error <rlang_error>
      All odd numbered `...` inputs must be size 6.
      i `..1` is size 2.

---

    Code
      replace_when(5:10, rep(TRUE, 6), 2:3)
    Error <vctrs_error_assert_size>
      `..2` must have size 6, not size 2.

# is type stable on `x`

    Code
      replace_when(1L, TRUE, 1, FALSE, "x")
    Error <vctrs_error_incompatible_type>
      Can't convert `..4` <character> to <integer>.

# `...` can't be empty

    Code
      replace_when(1)
    Error <rlang_error>
      `...` can't be empty.

