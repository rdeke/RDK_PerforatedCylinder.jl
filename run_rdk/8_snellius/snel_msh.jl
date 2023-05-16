using PerforatedCylinder

# Paths
const project_root = "../.."
const data_dir = project_root * "/data"
const OVERWRITE = true

# Define cases
println("Generating meshes...")
n1 = 3:30           # 28 samples
β = 0.1:0.05:0.85    # 16 samples --> 448 samples total
n2 = 3:12           # 10 samples
α = 0:0.05:0.5      # 10 samples --> 100 samples total   --> 548 samples

# Changed default lengths
mesh_cases1 = PerforatedCylinder.generate_meshes(; nperf=n1, nβ=β, do_mesh=true)
mesh_cases2 = PerforatedCylinder.generate_meshes(; nperf=n2, nα=α, do_mesh=true)
mesh_cases = vcat(mesh_cases1, mesh_cases2)
using DelimitedFiles
writedlm("generated_meshes.txt", mesh_cases)
