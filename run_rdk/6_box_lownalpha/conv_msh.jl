using PerforatedCylinder

# Paths
const project_root = "../.."
const data_dir = project_root * "/data"
const OVERWRITE = true

# Define cases
println("Generating meshes...")
n = [5, 6]
α = [0, 1/6, 2/6, 3/6]

mesh_cases = PerforatedCylinder.generate_meshes(; nperf=n, nα=α, do_mesh=true)
using DelimitedFiles
writedlm("generated_meshes.txt", mesh_cases)
