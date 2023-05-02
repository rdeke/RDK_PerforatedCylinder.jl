# Get smallest cell -- determine dt based on CFL limits
# Lengths needed --> 2/3/4/5/6/7/8/9/10 diameters behind ro R_L = 4-12
##--> https://www.sciencedirect.com/science/article/pii/S2405844021008264 says 3 


import Gmsh: gmsh
using Gridap
using GridapGmsh
include("../../src/mesh_generation.jl")

ENV["PerforatedCylinder_MESHES"]=pwd()
meshfile = "data/meshes/cellsize.msh"
create_mesh(filename=meshfile, n = 5, α=360/12/2)

# model =  GmshDiscreteModel(meshfile)
# Ω_f = Triangulation(model, tags = "fluid")
# cellsizes = Gridap.CellData.get_cell_measure(Ω_f)
# smallest = minimum(sqrt.(cellsizes))
# println(smallest)