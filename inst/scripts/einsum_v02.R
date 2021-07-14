library(einsum)

mat1 <- matrix(rnorm(n = 4 * 8), nrow = 4, ncol = 8)
mat1
mat2 <- einsum("ij->ji", mat1)
mat2

arrA <- array(runif(3), dim=c(3))
arrB <- array(runif(3*3), dim=c(3,3))
arrC <- array(runif(3*4), dim=c(3,4))
arrD <- array(runif(3*3*3), dim=c(3,3,3))
arrE <- array(runif(3*4*5), dim=c(3,4,5))

arrA
einsum::einsum('i->i', arrA)

arrA
einsum::einsum('i->iii', arrA)

arrA
einsum::einsum('i->', arrA)

arrC
einsum::einsum('ij->ij', arrC)

arrE
einsum::einsum('ijk->ijk', arrE)

arrB
einsum::einsum('ii->i', arrB)

arrD
einsum::einsum('iii->i', arrD)

arrA
einsum::einsum('i,i->i', arrA, arrA)

arrC
einsum::einsum('ij,ij->ij', arrC, arrC)

arrA
einsum::einsum('i,j->ij', arrA, arrA)

arrA
sum(arrA)
einsum::einsum('i->', arrA)

arrC
einsum::einsum('ij->', arrC)

arrE
einsum::einsum('ijk->ij', arrE)


