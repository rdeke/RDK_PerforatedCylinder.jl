module PerforatedCylinder

using Gridap
using Gridap.FESpaces: zero_free_values, interpolate!
using Gridap.Fields: meas
using GridapGmsh: gmsh, GmshDiscreteModel
using GridapDistributed
using GridapDistributed: DistributedTriangulation, DistributedCellField
using GridapPETSc
using GridapPETSc: PETSC
using PartitionedArrays
using SparseMatricesCSR

using CSV
using DataFrames

include("NavierStokesParallel.jl")
include("mesh_generation.jl")

function generate_meshes(; nD=[10], nRt=[100], nperf=[12], nβ=[0.5], nα=[0], nR_L=[7], do_mesh=true)
  # Create cases
  cases = []
  # RDK values
  for D in nD
    for Rt in nRt
      for num_perforations in nperf
        for β in nβ
          for α in nα
            for R_L in nR_L
                D2 =  round(D;digits=2)
                Rt2 = round(Rt;digits=0)
                β2 =  round(β;digits=2)
                α2 =  round(α,digits=2)
                filename = "D$D2-Rt$Rt2-n$num_perforations-beta$β2-alfa$α2-RL$R_L.msh"
                push!(cases,replace(filename, r".msh"=>""))

                if do_mesh==true
                  create_mesh(filename=filename, D=D, R_t=Rt, num_perforations=num_perforations, R_β=β, α=360/num_perforations*α,
                              R_L=R_L, R_Cx=R_L-5.5)
                end
              end
          end
        end
      end
    end
  end

  return cases

end

options_mumps = "-snes_type newtonls \
-snes_linesearch_type basic  \
-snes_linesearch_damping 1.0 \
-snes_rtol 1.0e-8 \
-snes_atol 1.0e-10 \
-ksp_error_if_not_converged true \
-ksp_converged_reason -ksp_type preonly \
-pc_type lu \
-pc_factor_mat_solver_type mumps \
-mat_mumps_icntl_7 0"


function main_parallel(np;
  mesh_file="tmp_mesh_coarse.msh", # was originally test_conformal_mesh.msh 
  vtk_outpath="tmp_mesh_coarse",
  Vinf=1,
  Δt=0.1,
  tf=1.0,
  Δtout=0.5,
  output_path=joinpath(ENV["PerforatedCylinder_DATA"],"vtk"))

  filename = replace(mesh_file, r".msh"=>"")
  run_name = filename*"-Vinf$Vinf-dt$Δt"

  current_path = pwd()
  cd(output_path)
  with_backend(MPIBackend(),np) do parts
    options = options_mumps
    GridapPETSc.with(args=split(options)) do
      run_test_parallel(parts,run_name,mesh_file,vtk_outpath,Vinf,Δt,tf,Δtout)
    end
  end
  cd(current_path)
end

end
