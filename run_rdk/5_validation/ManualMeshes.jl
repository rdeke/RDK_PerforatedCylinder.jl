# Get smallest cell -- determine dt based on CFL limits
# Lengths needed --> 2/3/4/5/6/7/8/9/10 diameters behind ro R_L = 4-12
##--> https://www.sciencedirect.com/science/article/pii/S2405844021008264 says 3 


import Gmsh: gmsh
using Gridap
using GridapGmsh
include("../../src/mesh_generation.jl")

# Define cases
println("Generating meshes...")
valid = ["Closed", "Star", "Oriol"]
D = [10, 10, 1]
n_perf = [0, 12, 12]
V_inf_shape = ["u", "p", "u"] # uniform, parabolic
t_wall = [100, 50, 20]
Rh = [3, 4, 5]
Rl = [7, 5, 10]
Cx = [1.5, 2, 4]
exp_wake = [2, 2, 5]

ENV["PerforatedCylinder_MESHES"]=pwd()
cases = []
for i in 1:3
    D2 =  round(D[i];digits=2)
    Rt2 = round(t_wall[i];digits=0)
    n_perf2 = n_perf[i]
    β2 =  0.5
    α2 = 0
    validopt = valid[i]
    mesh = "D$D2-Rt$Rt2-n$n_perf2-beta$β2-alfa$α2-$validopt.msh"
    meshfile = "data/meshes/"*mesh
    create_mesh(filename=meshfile, D=D2, R_t=Rt2, num_perforations=n_perf2, 
                R_H=Rh[i], R_L=Rl[i], R_Cx=Cx[i], exp_wake=exp_wake[i])
    push!(cases,replace(mesh, r".msh"=>""))
end

using DelimitedFiles
writedlm("run_rdk/5_validation/generated_meshes.txt", cases)