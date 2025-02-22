\name{Family}
\alias{Family}
\alias{AdaExp}
\alias{Binomial}
\alias{GaussClass}
\alias{GaussReg}
\alias{Gaussian}
\alias{Huber}
\alias{Laplace}
\alias{Poisson}
\alias{GammaReg}
\alias{CoxPH}
\alias{QuantReg}
\alias{ExpectReg}
\alias{NBinomial}
\alias{PropOdds}
\alias{Weibull}
\alias{Loglog}
\alias{Lognormal}
\alias{AUC}
\alias{Gehan}
\alias{Hurdle}
\alias{Multinomial}
\alias{Cindex}
\alias{RCG}

\title{ Gradient Boosting Families }
\description{
    \code{boost_family} objects provide a convenient way to specify loss functions
    and corresponding risk functions to be optimized by one of the boosting
    algorithms implemented in this package.
}
\usage{
Family(ngradient, loss = NULL, risk = NULL,
       offset = function(y, w)
           optimize(risk, interval = range(y),
                    y = y, w = w)$minimum,
       check_y = function(y) y,
       weights = c("any", "none", "zeroone", "case"),
       nuisance = function() return(NA),
       name = "user-specified", fW = NULL,
       response = function(f) NA,
       rclass = function(f) NA)
AdaExp()
AUC()
Binomial(type = c("adaboost", "glm"),
         link = c("logit", "probit", "cloglog", "cauchit", "log"), ...)
GaussClass()
GaussReg()
Gaussian()
Huber(d = NULL)
Laplace()
Poisson()
GammaReg(nuirange = c(0, 100))
CoxPH()
QuantReg(tau = 0.5, qoffset = 0.5)
ExpectReg(tau = 0.5)
NBinomial(nuirange = c(0, 100))
PropOdds(nuirange = c(-0.5, -1), offrange = c(-5, 5))
Weibull(nuirange = c(0, 100))
Loglog(nuirange = c(0, 100))
Lognormal(nuirange = c(0, 100))
Gehan()
Hurdle(nuirange = c(0, 100))
Multinomial()
Cindex(sigma = 0.1, ipcw = 1)
RCG(nuirange = c(0, 1), offrange = c(-5, 5))

}
\arguments{
  \item{ngradient}{ a function with arguments \code{y}, \code{f} and \code{w} implementing the
                    \emph{negative} gradient of the \code{loss} function (which is to be minimized). }
  \item{loss}{ an optional loss function with arguments \code{y} and \code{f}. }
  \item{risk}{ an optional risk function with arguments \code{y}, \code{f} and \code{w} to be minimized (!),
               the weighted mean of the loss function by default. }
  \item{offset}{ a function with argument \code{y} and \code{w} (weights)
                 for computing a \emph{scalar} offset. }
  \item{fW}{ transformation of the fit for the diagonal weights matrix for an
             approximation of the boosting hat matrix for loss functions other than
             squared error.}
  \item{response}{ inverse link function of a GLM or any other transformation
                   on the scale of the response.}
  \item{rclass}{ function to derive class predictions from conditional class
                   probabilities (for models with factor response variable).}
  \item{check_y}{ a function for checking and transforming
                  the class / mode of a response variable.}
  \item{nuisance}{ a function for extracting nuisance parameters from the family.}
  \item{weights}{ a character indicating what type of weights are
    allowed. These can be either arbitrary (non-negative) weights
    code{"any"}, only zero and one weights \code{"zeroone"},
    (non-negative) interger weights \code{"case"}, or no weights are
    allowed \code{"none"}.}
  \item{name}{ a character giving the name of the loss function for pretty printing. }
  \item{type}{ which parameterization of \code{Binomial} shoule be used?} b
  \item{link}{ link function. For possible values see Usage section.}
  \item{d}{ delta parameter for Huber loss function. If omitted, it is chosen adaptively.}
  \item{tau}{ the quantile or expectile to be estimated, a number strictly between 0 and 1.}
  \item{qoffset}{ quantile of response distribution to be used as offset, i.e., 
      starting values for the intercept. Per default the median of the response is used,
      which is in general a good choice (see Fenske et al. 2011, for details).}
  \item{nuirange}{ a vector containing the end-points of the interval to be
          searched for the minimum risk w.r.t. the nuisance parameter.
	  In case of \code{PropOdds}, the starting values for
	  the nuisance parameters. }
  \item{offrange}{ interval to search in for offset.}
  \item{sigma}{smoothness parameter for sigmoid functions inside \code{Cindex}.}
  \item{ipcw}{vector containing inverse probability of censoring weights for all observations. If omitted, it is estimated inside \code{Cindex} family.}
  \item{\dots}{ additional arguments to link functions.}
}

\details{
  The boosting algorithm implemented in \code{\link{mboost}} minimizes the
  (weighted) empirical risk function \code{risk(y, f, w)} with respect to \code{f}.
  By default, the risk function is the weighted sum of the loss function \code{loss(y, f)}
  but can be chosen arbitrarily. The \code{ngradient(y, f)} function is the negative
  gradient of \code{loss(y, f)} with respect to \code{f}.

  Pre-fabricated functions for the most commonly used loss functions are
  available as well. Buehlmann and Hothorn (2007) give a detailed
  overview of the available loss functions. An updated overview can 
  be found in Hofner et al (2014). 
  
  The \code{offset} function returns the population minimizers evaluated at the 
  response, i.e., \eqn{1/2 \log(p / (1 - p))} for \code{Binomial()} or \code{AdaExp()}
  and \eqn{(\sum w_i)^{-1} \sum w_i y_i} for \code{Gaussian()} and the
  median for \code{Huber()} and \code{Laplace()}. The offset is used as starting 
  value for the boosting algorithm.
  
  Note that all families are functions and thus need to be specified either with
  empty brackets (e.g., \code{family = Gaussian()} for Gaussian regression) or 
  with additional arguments if these are supported by the respective family 
  (e.g., \code{family = QuantReg(tau = 0.2)} for quantile regression for the 
  20\% quantile).
  
  \strong{A short summary of the available families is given in the following paragraphs:}

\code{AdaExp()}, \code{Binomial()} and \code{AUC()} implement
families for binary classification. \code{AdaExp()} uses the
exponential loss, which essentially leads to the AdaBoost algorithm
of Freund and Schapire (1996). \code{Binomial()} implements the
negative binomial log-likelihood of a logistic regression model
as loss function. Thus, using \code{Binomial} family closely corresponds
to fitting a logistic model. Alternative link functions
can be specified.

However, the coefficients resulting from boosting with family
\code{Binomial(link = "logit")} are \eqn{1/2} of the coefficients of a logit model
obtained via \code{\link{glm}}.  Buehlmann and Hothorn (2007) argue that the
family \code{Binomial} is the preferred choice for binary
classification. For binary classification problems the response
\code{y} has to be a \code{factor}. Internally \code{y} is re-coded
to \eqn{-1} and \eqn{+1} (Buehlmann and Hothorn 2007). 

\code{Binomial(type = "glm")} is an alternative to \code{Binomial()} leading to 
coefficients of the same size as coefficients from a classical logit 
model via \code{\link{glm}}. Additionally, it works not only with a 
two-level factor but also with a two-column matrix containing the number 
of successes and number of failures (again, similar to \code{\link{glm}}). 

\code{AUC()} uses \eqn{1-AUC(y, f)} as the loss function.
The area under the ROC curve (AUC) is defined as
\eqn{AUC = (n_{-1} n_1)^{-1} \sum_{i: y_i = 1} \sum_{j: y_j = -1} I(f_i > f_j)}.
Since this is not differentiable in \code{f}, we approximate the jump function
\eqn{I((f_i - f_j) > 0)} by the distribution function of the triangular
distribution on \eqn{[-1, 1]} with mean \eqn{0}, similar to the logistic
distribution approximation used in Ma and Huang (2005).

  \code{Gaussian()} is the default family in \code{\link{mboost}}. It
  implements \eqn{L_2}Boosting for continuous response. Note
  that families \code{GaussReg()} and \code{GaussClass()} (for regression
  and classification) are deprecated now.
  \code{Huber()} implements a robust version for boosting with
  continuous response, where the Huber-loss is used. \code{Laplace()}
  implements another strategy for continuous outcomes and uses the
  \eqn{L_1}-loss instead of the \eqn{L_2}-loss as used by
  \code{Gaussian()}.

  \code{Poisson()} implements a family for fitting count data with
  boosting methods. The implemented loss function is the negative
  Poisson log-likelihood. Note that the natural link function
  \eqn{\log(\mu) = \eta} is assumed. The default step-site \code{nu = 0.1}
  is probably too large for this family (leading to
  infinite residuals) and smaller values are more appropriate.

  \code{GammaReg()} implements a family for fitting nonnegative response
  variables. The implemented loss function is the negative Gamma
  log-likelihood with logarithmic link function (instead of the natural
  link).

  \code{CoxPH()} implements the negative partial log-likelihood for Cox
  models. Hence, survival models can be boosted using this family.

  \code{QuantReg()} implements boosting for quantile regression, which is
  introduced in Fenske et al. (2009). \code{ExpectReg} works in analogy,
  only for expectiles, which were introduced to regression by Newey and Powell (1987).

  Families with an additional scale parameter can be used for fitting
  models as well: \code{PropOdds()} leads to proportional odds models
  for ordinal outcome variables (Schmid et al., 2011). When using this
  family, an ordered set of threshold parameters is re-estimated in each
  boosting iteration. An example is given below which also shows how to
  obtain the thresholds. \code{NBinomial()} leads to regression models with
  a negative binomial conditional distribution of the response.
  \code{Weibull()}, \code{Loglog()}, and \code{Lognormal()} implement
  the negative log-likelihood functions of accelerated failure time
  models with Weibull, log-logistic, and lognormal distributed outcomes,
  respectively. Hence, parametric survival models can be boosted using
  these families. For details see Schmid and Hothorn (2008) and Schmid
  et al. (2010).

  \code{Gehan()} implements rank-based estimation of survival data in an
  accelerated failure time model. The loss function is defined as the sum
  of the pairwise absolute differences of residuals. The response needs to
  be defined as \code{Surv(y, delta)}, where \code{y} is the observed survial
  time (subject to censoring) and \code{delta} is the non-censoring indicator
  (see \code{\link{Surv}} for details). For details on \code{Gehan()} see
  Johnson and Long (2011).

  \code{Cindex()} optimizes the concordance-index for survival data (often denoted
  as Harrell's C or C-index). The concordance index evaluates the rank-based
  concordance probability between the model and the outcome. The C-index measures
  whether large values of the model are associated with short survival times  and
  vice versa. The interpretation is similar to the AUC: A C-index of 1 represents a
  perfect discrimination while a C-index of 0.5 will be achieved by a completely
  non-informative marker. The \code{Cindex()} family is based on an estimator by
  Uno et al. (2011), which incorporates inverse probability of censoring weighting
  \code{ipcw}. To make the estimator differentiable, sigmoid functions are applied;
  the corresponding smoothness can be controlled via \code{sigma}. For details on
  \code{Cindex()} see Mayr and Schmid (2014).
    
  
  Hurdle models for zero-inflated count data can be fitted by using a combination
  of the \code{Binomial()} and \code{Hurdle()} families. While the \code{Binomial()}
  family allows for fitting the zero-generating process of the Hurdle model,
  \code{Hurdle()} fits a negative binomial regression model to the non-zero
  counts. Note that the specification of the Hurdle model allows for using
  \code{Binomial()} and \code{Hurdle()} independently of each other.

  Linear or additive multinomial logit models can be fitted using
  \code{Multinomial()}; although is family requires some extra effort for
  model specification (see example).  More specifically, the predictor must
  be in the form of a linear array model (see \code{\link{\%O\%}}).  Note
  that this family does not work with tree-based base-learners at the
  moment. The class corresponding to the last level of the factor coding
  of the response is used as reference class.
  
  \code{RCG()} implements the ratio of correlated gammas (RCG) model proposed
  by Weinhold et al. (2016).

}
\section{Warning}{
  The coefficients resulting from boosting with family
  \code{Binomial(link = "logit")} are \eqn{1/2} of the coefficients of a logit model
  obtained via \code{\link{glm}} (see above). 

  For \code{AUC()}, variables should be centered and scaled and observations with weight > 0 must not contain missing values.
  The estimated coefficients for \code{AUC()} have no probabilistic interpretation.
}
\value{
  An object of class \code{boost_family}.
}
\references{
    Peter Buehlmann and Torsten Hothorn (2007),
    Boosting algorithms: regularization, prediction and model fitting.
    \emph{Statistical Science}, \bold{22}(4), 477--505.

    Nora Fenske, Thomas Kneib, and Torsten Hothorn (2011),
    Identifying risk factors for severe childhood malnutrition by
    boosting additive quantile regression.
	\emph{Journal of the American Statistical Association}, \bold{106}:494-510.

    Yoav Freund and Robert E. Schapire (1996),
    Experiments with a new boosting algorithm.
    In \emph{Machine Learning: Proc. Thirteenth International Conference},
    148--156.

    Shuangge Ma and Jian Huang (2005), Regularized ROC method for
    disease classification and biomarker selection with microarray
    data. \emph{Bioinformatics}, \bold{21}(24), 4356--4362.
    
    Andreas Mayr and Matthias Schmid (2014). 
    Boosting the concordance index for survival data -- a unified 
    framework to derive and evaluate biomarker combination.     
    \emph{PloS ONE}, \bold{9}(1):84483.

    Whitney K. Newey and James L. Powell (1987),
    Asymmetric least squares estimation and testing.
    \emph{Econometrika}, \bold{55}, 819--847.

    Matthias Schmid and Torsten Hothorn (2008),
    Flexible boosting of accelerated failure time models.
    \emph{BMC Bioinformatics}, \bold{9}(269).

    Matthias Schmid, Sergej Potapov, Annette Pfahlberg,
    and Torsten Hothorn (2010). Estimation and regularization techniques for
    regression models with multidimensional prediction functions.
    \emph{Statistics and Computing}, \bold{20}, 139--150.

    Schmid, M., T. Hothorn, K. O. Maloney, D. E. Weller and S. Potapov
    (2011): Geoadditive regression modeling of stream biological
    condition. \emph{Environmental and Ecological Statistics},
    \bold{18}(4), 709--733.

    Uno H, Cai T, Pencina MJ, D Agostino RB and Wei LJ (2011). 
    On the C-statistics for evaluating overall adequacy of risk prediction 
    procedures with censored survival data. 
    \emph{Statistics in Medicine}, \bold{30}(10), 1105--17.

    Benjamin Hofner, Andreas Mayr, Nikolay Robinzonov and Matthias Schmid
    (2014). Model-based Boosting in R: A Hands-on Tutorial Using the R
    Package mboost. \emph{Computational Statistics}, \bold{29}, 3--35.\cr
    \doi{10.1007/s00180-012-0382-5}

    Available as vignette via: \code{vignette(package = "mboost", "mboost_tutorial")}

    Brent A. Johnson and Qi Long (2011) Survival ensembles by the sum of pairwise
    differences with application to lung cancer microarray studies.
    \emph{Annals of Applied Statistics}, \bold{5}, 1081--1101.
    

    Weinhold, L., S. Pechlivanis, S. Wahl, P. Hoffmann and M. Schmid (2016) A Statistical Model for the
    Analysis of Bounded Response Variables in DNA Methylation Studies.
    \emph{BMC Bioinformatics}. 2016; 17: 480. \doi{10.1186/s12859-016-1347-4}
}
\seealso{\code{\link{mboost}} for the usage of \code{Family}s. See
    \code{\link{boost_family-class}} for objects resulting from a call to \code{Family}. }
\author{
    \code{ExpectReg()} was donated by Fabian Sobotka.
    \code{AUC()} was donated by Fabian Scheipl.
}
\examples{
### Define a new family
MyGaussian <- function(){
       Family(ngradient = function(y, f, w = 1) y - f,
       loss = function(y, f) (y - f)^2,
       name = "My Gauss Variant")
}
# Now use the new family
data(bodyfat, package = "TH.data")
mod <- mboost(DEXfat ~ ., data = bodyfat, family = MyGaussian())
# N.B. that the family needs to be called with empty brackets


### Proportional odds model
data(iris)
iris$Species <- factor(iris$Species, ordered = TRUE)
if (require("MASS")) {
    (mod.polr <- polr(Species  ~ Sepal.Length, data = iris))
}
mod.PropOdds <- glmboost(Species  ~ Sepal.Length, data = iris,
                         family = PropOdds(nuirange = c(-0.5, 3)))
mstop(mod.PropOdds) <- 1000
## thresholds are treated as nuisance parameters, to extract these use
nuisance(mod.PropOdds)
## effect estimate
coef(mod.PropOdds)["Sepal.Length"]
## make thresholds comparable to a model without intercept
nuisance(mod.PropOdds) - coef(mod.PropOdds)["(Intercept)"] -
    attr(coef(mod.PropOdds), "offset")

### Multinomial logit model via a linear array model
## One needs to convert the data to a list
myiris <- as.list(iris)
## ... and define a dummy vector with one factor level less
## than the outcome, which is used as reference category.
myiris$class <- factor(levels(iris$Species)[-nlevels(iris$Species)])
## Now fit the linear array model
mlm <- mboost(Species ~ bols(Sepal.Length, df = 2) \%O\%
                        bols(class, df = 2, contrasts.arg = "contr.dummy"),
              data = myiris,
              family = Multinomial())
coef(mlm) ## one should use more boosting iterations.
head(round(pred <- predict(mlm, type = "response"), 2))

## Prediction with new data:
newdata <- as.list(iris[1,])
## One always needs to keep the dummy vector class as above!
newdata$class <- factor(levels(iris$Species)[-nlevels(iris$Species)])
pred2 <- predict(mlm, type = "response", newdata = newdata)
## check results
pred[1, ]
pred2

\dontrun{############################################################
## Do not run and check these examples automatically as
## they take some time

## Compare results with nnet::multinom
if (require("nnet")) {
    mlmn <- multinom(Species ~ Sepal.Length, data = iris)
    max(abs(fitted(mlm[1000], type = "response") -
            fitted(mlmn, type = "prob")))
}

## End(Not run and test)
}


### Example for RCG model
## generate covariate values
set.seed(12345)
x1 <- rnorm(500)
x2 <- rnorm(500)
## generate linear predictors
zetaM <- 0.1 + 0.3 * x1 - 0.5 * x2 
zetaU <- 0.1 - 0.1 * x1 + 0.2 * x2
## generate beta values
M <- rgamma(500, shape = 2, rate = exp(zetaM))
U <- rgamma(500, shape = 2, rate = exp(zetaU))
y <- M / (M + U)

## fit RCG model
data <- data.frame(y, x1, x2)
RCGmodel <- glmboost(y ~ x1 + x2, data = data, family = RCG(),
                     control = boost_control(mstop = 1000,
                     trace = TRUE, nu = 0.01))
## true coefficients: gamma = (0.0, 0.4, -0.7),
##                    alpha (= shape) = 2,
##                    rho = 0
## compare to coefficient estimates
coef(RCGmodel)
nuisance(RCGmodel)

## compute downstream tests 
## (only suitable without early stopping, i.e., if likelihood based model converged)
downstream.test(RCGmodel)

## compute conditional expectations
predictions <- predict(RCGmodel, type = "response")
plot(predictions, y)
abline(0,1)

}
\keyword{models}
