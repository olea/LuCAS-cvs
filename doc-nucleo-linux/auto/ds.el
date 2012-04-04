(TeX-add-style-hook "ds"
 (function
  (lambda ()
    (LaTeX-add-labels
     "ds-chapter")
    (TeX-run-style-hooks
     "ds/blk_dev_struct"
     "ds/buffer_head"
     "ds/device"
     "ds/device_struct"
     "ds/file"
     "ds/files_struct"
     "ds/fs_struct"
     "ds/gendisk"
     "ds/inode"
     "ds/ipc_perm"
     "ds/irqaction"
     "ds/linux_binfmt"
     "ds/mem_map_t"
     "ds/mm_struct"
     "ds/pci_bus"
     "ds/pci_dev"
     "ds/request"
     "ds/rtable"
     "ds/semaphore"
     "ds/sk_buff"
     "ds/sock"
     "ds/socket"
     "ds/task_struct"
     "ds/timer_list"
     "ds/tq_struct"
     "ds/vm_area_struct"))))

