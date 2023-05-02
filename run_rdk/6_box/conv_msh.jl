using PerforatedCylinder

# Paths
const project_root = "../.."
const data_dir = project_root * "/data"
const OVERWRITE = true

# Define cases
println("Generating meshes...")
D = [10, 8, 12] # includes the reference case
Rt = [90, 110]
n = [7, 17]
β = [0.4, 0.6]
α = [1/4, 1/2]

mesh_cases1 = PerforatedCylinder.generate_meshes(; nD=D, do_mesh=true)
mesh_cases2 = PerforatedCylinder.generate_meshes(; nRt=Rt, do_mesh=true)
mesh_cases3 = PerforatedCylinder.generate_meshes(; nperf=n, do_mesh=true)
mesh_cases4 = PerforatedCylinder.generate_meshes(; nβ=β, do_mesh=true)
mesh_cases5 = PerforatedCylinder.generate_meshes(; nα=α , do_mesh=true)
mesh_cases = vcat(mesh_cases1, mesh_cases2, mesh_cases3, mesh_cases4, mesh_cases5)

using DelimitedFiles
writedlm("generated_meshes.txt", mesh_cases)
