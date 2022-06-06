function [out] = apply_GenAncombe(in,p,forward)

alpha = p(1);
sigma = sqrt(max(p(2), 0));
g = max(-p(2), 0) / alpha;

if forward
    out = GenAnscombe_forward(in, sigma, alpha, g);
else
%     out = GenAnscombe_inverse_closed_form(in,sigma,alpha,g);
    out = GenAnscombe_inverse_exact_unbiased(in,sigma,alpha,g);
end