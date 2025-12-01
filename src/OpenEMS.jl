module OpenEMS

if !haskey(ENV, "JULIA_PYTHONCALL_EXE")
    ENV["JULIA_PYTHONCALL_EXE"] = joinpath(homedir(), ".local", "openEMS", "venv", "bin", "python")
end

ENV["JULIA_CONDAPKG_BACKEND"] = "Null"

using PythonCall

CSXCAD = pyimport("CSXCAD")
openEMS = pyimport("openEMS")

export CSXCAD, openEMS




end
