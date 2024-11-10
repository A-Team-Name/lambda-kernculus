# Lambda Kernculus

```bash
# in the root of the repo, installs the python code
pip install -e .

# in the root of the repo, installs the kernel spec
jupyter kernelspec install --user ./lambda-kernculus/lambda-calculus

# to taste
jupyter console --kernel lambda-calculus
```

TODO:

- must
    - [x] basic jupyter interface
    - [ ] parsing and evaluating lambda calc, returning normal form
    - [ ] generating and returning typeset images for reductions
- could
    - configuration of normal order, applicative order
    - assignment, types etc
