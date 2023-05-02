using PerforatedCylinder

# Paths
const project_root = "../.."
const data_dir = project_root * "/data"
const OVERWRITE = true

# Define cases
println("Generating meshes...")
# nD=[10], nRt=[100], nperf=[12],nβ=[0.5],nα=[0] --> sequence
nD = [8, 12]
nperf = [7, 23]
mesh_cases = PerforatedCylinder.generate_meshes(; nD=nD, nperf=nperf, do_mesh=true)
# cases are of shape "D$D2-Rt$Rt2-n$num_perforations2-β$β2-α$α2 --> add velo and dt

using DelimitedFiles
writedlm("generated_meshes.txt", mesh_cases)
