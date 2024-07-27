cmake_minimum_required(VERSION 3.25)

project(elves)

find_program(AS_EXE as)
find_program(OBJCOPY_EXE objcopy)
find_program(CHMOD_EXE chmod)
find_program(RM_EXE rm)

set(SOURCES
  ${PROJECT_SOURCE_DIR}/sources/tiny_32.S
  ${PROJECT_SOURCE_DIR}/sources/small_32.S
  ${PROJECT_SOURCE_DIR}/sources/small_64.S
  ${PROJECT_SOURCE_DIR}/sources/printf_32.S
  ${PROJECT_SOURCE_DIR}/sources/dynamic_32.S
  ${PROJECT_SOURCE_DIR}/sources/dynamic_64.S
)

foreach(FILE_PATH ${SOURCES})
  get_filename_component(FILE_NAME ${FILE_PATH} NAME_WE)

  string(REGEX MATCH "[0-9]+" BITS "${FILE_NAME}")

  set(ASM_PATH ${CMAKE_BINARY_DIR}/${FILE_NAME}.asm)
  set(OBJ_PATH ${CMAKE_BINARY_DIR}/${FILE_NAME}.o)
  set(OUT_PATH ${CMAKE_BINARY_DIR}/${FILE_NAME}.out)

  add_custom_command(OUTPUT ${ASM_PATH}
    COMMAND ${CMAKE_C_COMPILER} -E ${FILE_PATH} -o ${ASM_PATH}
    DEPENDS ${FILE_PATH}
    VERBATIM
  )

  add_custom_command(OUTPUT ${OBJ_PATH}
    COMMAND ${AS_EXE} -a --${BITS} -o ${OBJ_PATH} ${ASM_PATH}
    DEPENDS ${ASM_PATH}
    VERBATIM
  )

  add_custom_command(OUTPUT ${OUT_PATH}
    COMMAND ${OBJCOPY_EXE} -O binary ${OBJ_PATH} ${OUT_PATH}
    COMMAND ${CHMOD_EXE} +x ${OUT_PATH}
    DEPENDS ${OBJ_PATH}
    VERBATIM
  )

  add_custom_target(${FILE_NAME}_out ALL DEPENDS ${OUT_PATH})
endforeach()




