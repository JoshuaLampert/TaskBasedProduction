"""
    margProdLabor_general(labor_input::AbstractArray{<:Real}, z::Real, b_g::Function, e_h::Vector{Function}) -> AbstractArray{<:Real}

Calculates the marginal productivity of labor for each worker type given the input parameters.

# Arguments
- `labor_input`: An array of labor inputs of different types with H elements.
- `z`: A productivity scalar.
- `b_g`: A task density function.
- `e_h`: A vector of comparative advantage functions.

# Returns
- An array representing the marginal productivity of labor for each worker type.
"""
function margProdLabor_general(labor_input::AbstractArray{<:Real}, z::Real, b_g:: Function, e_h::Vector{Function})
    q, xT= prod_fun_general(labor_input,z,b_g, e_h)
    H = length(e_h)
    mpl_over_mpl1 = [1.0]
    # Calculate the ratio e_{h} / e_{h-1} for h = 2:H and evaluate at xT[h-1]
    temp = zeros(H-1)
    for h in 2:H
        ratio_value = e_h[h](xT[h-1]) / e_h[h-1](xT[h-1])
        temp[h-1]=ratio_value
    end
    mpl_over_mpl1=[1; cumprod(temp,dims=1)]
    mpl1 = 1 / sum(mpl_over_mpl1 .* labor_input)
    mpl = mpl_over_mpl1 * mpl1
    return mpl
end