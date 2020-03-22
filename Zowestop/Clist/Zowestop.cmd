/*REXX */
/*                                                                   */
/* Rexx to cancel Zowe jobs (STARTED)                                */
/* Usage: ZOWESTOP <Zowe started task name>                          */
/*                                                                   */
/*                                                                   */
/* Xact Consulting A/S 2020                                          */

  parse arg ztask
  parse source . . RexxName .

  IsfRC = isfcalls("ON")

  if IsfRC <> 0 then do
     say RexxName": isfcalls Error. RC:" IsfRC
     call msgrtn
     exit
     end

  zrc = DoCancel(ztask,"C")

  call  isfcalls "OFF"

  return 0

/**********************************************************/
/* Subroutine for list and cancel of jobs                 */
/* Usage: DoCancel(jobname,"C/P") (Cancel or STOP)        */
/**********************************************************/
DoCancel:

 isfprefix = "*"
  isffilter = "jname = "arg(1)" workload = STARTED"
  isfcols   = "jname asidx"

  Address SDSF "isfexec da"

  if RC <> 0 then do
      say RexxName": isfexec  RC" RC
      call msgrtn
      return 12
      end

  if isfrows > 0 then do
     Say RexxName": Number of jobs for joname "arg(1) ": " isfrows
     do ix=1 to isfrows
        zrc = DoIcmd(arg(2)" "jname.ix",A="asidx.ix)
        end
     end
  else do
     Say RexxName": No jobs found with name: "jname.ix
     end

  return 0

/**********************************************************/
/* Subroutine to SDSF System Command                      */
/**********************************************************/
DoIcmd: procedure

  sdsfcmd.0 = 1
  sdsfcmd.1 = arg(1)

  Address SDSF ISFSLASH "("sdsfcmd.") (WAIT)"

  call msgrtn

  Return 0

/**********************************************************/
/* Subroutine for displaying error messages               */
/**********************************************************/
msgrtn: procedure expose isfmsg isfmsg2.

  if isfmsg<>"" then Say RexxName": isfmsg is:" isfmsg

  do ix=1 to isfmsg2.0
     Say RexxName": isfmsg2."ix "is:" isfmsg2.ix
     end

  return

